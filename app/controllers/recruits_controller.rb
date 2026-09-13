class RecruitsController < ApplicationController
  include RecruitVisitor

  before_action :authenticate_recruit_editor!, except: [:index, :show, :saved, :apply, :toggle_save]
  before_action :set_recruit, only: [:show, :edit, :update, :destroy, :apply, :toggle_save]
  before_action :authorize_recruit_owner!, only: [:edit, :update, :destroy]
  before_action :recruit_visitor_token, only: [:index, :show, :saved, :toggle_save]

  def index
    scope = Recruit.where.not(point: "0")
    @areas = scope.where.not(area: [nil, ""]).distinct.order(:area).pluck(:area)
    @genres = scope.where.not(genre: [nil, ""]).distinct.order(:genre).pluck(:genre)
    scope = scope.where(area: params[:area]) if params[:area].present?
    scope = scope.where(genre: params[:genre]) if params[:genre].present?
    @recruits = scope.order(updated_at: :desc)
    @saved_recruit_ids = saved_recruit_ids_for_visitor
  end

  def saved
    @saved_recruit_ids = saved_recruit_ids_for_visitor
    @recruits = Recruit.where(id: @saved_recruit_ids).order(updated_at: :desc)
  end

  def new
    @recruit = Recruit.new
    @source_url = nil
  end

  def import
    @source_url = params[:source_url].to_s.strip
    result = RecruitListingImporter.call(@source_url)
    @recruit = Recruit.new(result.attributes)

    if result.error.present?
      flash.now[:alert] = result.error
    else
      flash.now[:notice] = "掲載情報を読み込みました。内容を確認して保存してください。"
    end
    render :new
  end

  def create
    @recruit = Recruit.new(recruit_params)
    bind_client_id!(@recruit)
    @source_url = nil

    if @recruit.save
      redirect_to after_recruit_save_path, notice: "案件情報を登録しました"
    else
      flash.now[:alert] = @recruit.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
    track_recruit_view!
    @saved = @recruit.saved_by?(recruit_visitor_token)
  end

  def edit
  end

  def update
    if @recruit.update(recruit_params)
      redirect_to after_recruit_save_path, notice: "案件情報を登録しました"
    else
      render :edit
    end
  end

  def destroy
    @recruit.destroy
    redirect_to after_recruit_save_path, notice: '案件が削除されました。'
  end

  def apply
    @recruit.increment!(:applications_count)
    render json: { applications_count: @recruit.applications_count }
  end

  def toggle_save
    existing = @recruit.recruit_saves.find_by(visitor_token: recruit_visitor_token)

    if existing
      existing.destroy!
      saved = false
    else
      @recruit.recruit_saves.create!(visitor_token: recruit_visitor_token)
      saved = true
    end

    @recruit.reload
    render json: {
      saved: saved,
      saves_count: @recruit.saves_count
    }
  end

  private

  def set_recruit
    @recruit = Recruit.find(params[:id])
  end

  def authenticate_recruit_editor!
    return if admin_signed_in? || client_signed_in?

    redirect_to new_client_session_path, alert: "求人登録にはログインが必要です"
  end

  def authorize_recruit_owner!
    return if admin_signed_in?
    return if client_signed_in? && @recruit.client_id == current_client.id

    redirect_to recruits_path, alert: "権限がありません"
  end

  def bind_client_id!(recruit)
    return if admin_signed_in?

    recruit.client_id = current_client.id
  end

  def after_recruit_save_path
    if client_signed_in? && !admin_signed_in?
      client_mypage_path
    else
      recruits_path
    end
  end

  def track_recruit_view!
    viewed = Array(session[:recruit_viewed_ids]).map(&:to_i)
    return if viewed.include?(@recruit.id)

    @recruit.increment!(:views_count)
    session[:recruit_viewed_ids] = (viewed + [@recruit.id]).last(200)
  end

  def saved_recruit_ids_for_visitor
    RecruitSave.where(visitor_token: recruit_visitor_token).pluck(:recruit_id)
  end

  def recruit_params
    params.require(:recruit).permit(
      :title,
      :description,
      :unit_price,
      :reward,
      :working_hours,
      :working_days,
      :area,
      :payment,
      :japanese_skill,
      :require,
      :contract_type,
      :car_details,
      :remarks,
      :recommend,
      :point,
      :genre,
      visa: []
    )
  end
end
