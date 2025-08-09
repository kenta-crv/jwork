class PartnersController < ApplicationController
  #before_action :check_partner
  def index
    @partners = Partner.all
  end

  def show
    @partner = Partner.find(params[:id])
    #@estimates = current_partner.estimates
  end

  def disclose
    @partner = Partner.find(params[:id])
    @partner.update(disclosure_clicked_at: Time.current)
    # 開示された案件情報を表示するためのロジック
    redirect_to partner_path(@partner)
  end

  def info
    @partner = Partner.find(params[:id])  # 例：params[:id]から取得している想定
  end

  #def new
   # @partner = Partner.new
  #end

  def edit
    @partner = Partner.find(params[:id])
  end

  #def update
  #  @partner = Partner.find(params[:id])
  #  if @partner.update(partner_params)
  #    redirect_to @partner, notice: 'クライアント情報が更新されました。'
  #  else
  #    render :edit
  #  end
  #end

  def update
    @partner = Partner.find(params[:id])
  
    if @partner.update(partner_params)
      # conclusion.html.slimからの送信で、かつ同意が得られた場合
      if @partner.agree == "同意しました"
          # メール送信処理
          PartnerMailer.contract_received_email(@partner).deliver_now
          PartnerMailer.contract_send_email(@partner).deliver_now
          flash[:notice] = "契約が完了しました"
          redirect_to partner_path(@partner)
        # edit.html.slimからの送信、またはconclusion.html.slimからの送信でも同意が得られなかった場合
      else
        redirect_to partner_path(@partner)
      end
    else
      # 更新が失敗した場合の処理
      render :edit
    end
  end

  def conclusion
    @partner = Partner.find(params[:id])
    today = Date.today.strftime("%Y-%m-%d")
  end

  def destroy
    @partner = Partner.find(params[:id])
    @partner.destroy
    redirect_to partners_url, notice: 'クライアントが削除されました。'
  end

  def send_mail
    @partner = Partner.find(params[:id])
    PartnerMailer.received_first_email(@partner).deliver_now
    PartnerMailer.send_first_email(@partner).deliver_now
    redirect_to info_partner_path(@partner), notice: "#{@partner.company}へ契約依頼のメール送信を行いました。"
  end

  def send_mail_start
    @partner = Partner.find(params[:id])
    PartnerMailer.received_start_email(@partner).deliver_now
    PartnerMailer.send_start_email(@partner).deliver_now
    redirect_to info_partner_path(@partner), notice: "#{@partner.company}へ開始日のメール送信を行いました。"
  end

  private

  def partner_params
    params.require(:partner).permit(
      :partner_name, :email, :current_password, :password, :password_confirmation,
      :company, :post_title, :representative_name, :contact_name, :tel, :address, :url, :message,
      :recruit_url, :visa, :business, :genre, :salary, :work_time, :day_off, :work_contents, :number,
      :house_agents, :house_support, :remarks, :agree, :contract_date, :agree_1, :agree_2, :agree_3, :agree_4, :agree_5, :agree_6, :agree_7 
    )
  end
end