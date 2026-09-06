class RecruitsController < ApplicationController
  def index
    scope = Recruit.where.not(point: "0")
    @areas = scope.where.not(area: [nil, ""]).distinct.order(:area).pluck(:area)
    @genres = scope.where.not(genre: [nil, ""]).distinct.order(:genre).pluck(:genre)
    scope = scope.where(area: params[:area]) if params[:area].present?
    scope = scope.where(genre: params[:genre]) if params[:genre].present?
    @recruits = scope.order(updated_at: :desc)
  end

  def new
    @recruit = Recruit.new
  end

def create
  @recruit = Recruit.new(recruit_params)

  if @recruit.save
    redirect_to recruits_path, notice: "案件情報を登録しました"
  else
    flash.now[:alert] = @recruit.errors.full_messages.join(", ")
    render :new
  end
end

  def show
    @recruit = Recruit.find(params[:id])
  end

  def edit
    @recruit = Recruit.find(params[:id])
  end

  def update
    @recruit = Recruit.find(params[:id])
  
    if @recruit.update(recruit_params)
      redirect_to recruits_path, notice: "案件情報を登録しました"
    else
      render :edit
    end
  end

  def destroy
    @recruit = Recruit.find(params[:id])
    @recruit.destroy
    redirect_to recruits_url, notice: 'クライアントが削除されました。'
  end

  private
    # recruit または admin のどちらかでログインしていればOK
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
