class ContractsController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :destroy, :send_mail]  
  def index
    #@contracts = Contract.without_ng_status.order(created_at: :desc).page(params[:page])
    @contracts = Contract.order(created_at: :desc).page(params[:page])
  end

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      if admin_signed_in?
        ContractMailer.received_email(@contract).deliver # 管理者に通知
        flash[:notice] = "管理者送信のため、取引先にはメールを送らず完了しました。"
      #else
        # 一般ユーザーの場合はメール送信を行う
        #ContractMailer.received_email(@contract).deliver # 管理者に通知
        #ContractMailer.send_email(@contract).deliver # 送信者に通知
      end
      redirect_to contracts_path, notice: "契約が正常に作成されました。"
    else
      flash.now[:alert] = "入力内容にエラーがあります。"
      render :new
    end
  end
  
    def show
      @contract = Contract.find(params[:id])
      @comment = Comment.new
    end
  
    def edit
      @contract = Contract.find(params[:id])
    end

    def info
      @contract = Contract.find(params[:id])
    end
  
    def conclusion
      @contract = Contract.find(params[:id])
      today = Date.today.strftime("%Y-%m-%d")
    end

    def destroy
      @contract = Contract.find(params[:id])
      @contract.destroy
      redirect_to contracts_path, alert:"削除しました"
    end

    def send_mail
      @contract = Contract.find(params[:id])
      ContractMailer.received_first_email(@contract).deliver_now
      ContractMailer.send_first_email(@contract).deliver_now
      redirect_to info_contract_path(@contract), notice: "#{@contract.co}へ契約依頼のメール送信を行いました。"
    end

    def send_bulk_email
      work_id = params[:work_id] # works/:id を取得
      contract_ids = params[:contract_ids] # 選択された contracts/:id を取得
  
      if work_id.present? && contract_ids.present?
        work = Work.find(work_id) # 送信元の work を固定
        contracts = Contract.where(id: contract_ids)
  
        contracts.each do |contract|
          ContractMailer.with(contract: contract, work: work).send_contract_email.deliver_now
        end
  
        flash[:notice] = "#{contracts.size}件のメールを送信しました。"
      else
        flash[:alert] = "送信に必要な情報が不足しています。"
      end
  
      redirect_to work_path(work_id)
    end
  
    def update
      @contract = Contract.find(params[:id])
      was_agreed = @contract.agree # 現在の agree の値を保存
    
      if @contract.update(contract_params)
        if @contract.agree == "同意しました" && was_agreed != "同意しました"
          # agree が新たに "同意しました" に変更された場合のみメール送信
          ContractMailer.contract_received_email(@contract).deliver_now
          ContractMailer.contract_send_email(@contract).deliver_now
          flash[:notice] = "契約が完了しました。メールにて控えをお送りしております。"
        end
        redirect_to info_contract_path(@contract)
      else
        # 更新が失敗した場合の処理
        render :edit
      end
    end

      private
      def contract_params
        params.require(:contract).permit(
            :agree, #同意
            :co, #会社名
            :president_first,  #代表者姓
            :president_last,  #代表者名
            :tel, #電話番号
            :address, #ご住所住所
            :url, #会社HP
            :recruit_url, #採用ページ
            :work, #採用予定職種
            :qualifications, #希望資格
            :number, #採用予定人数
            :period, #希望採用予定日
            :remarks, #その他要望
            :person_first,  #採用担当姓
            :person_last,  #採用担当名
            :email, #採用担当メールアドレス
            :cc, #採用担当メールアドレス
            :post_title,
            :experience,
            :recruit_url_2,
            :pdf,
            :contract_date,
            :unit_price,
            :refund,
            :payment, #支払日
            :salary, #給与
            :employment_conditions, #採用条件
            :document_screening, #書類選考期間
            :conversion, #採択率
            :application, #申請代行可否
            :driver_licence, #ドライバーライセンス
            :housing, #住居
            :age        
            )
      end
  end
  