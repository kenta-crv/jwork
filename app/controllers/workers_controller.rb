class WorkersController < ApplicationController
    #before_action :authenticate_user!, only: [:index, :show]
    def index
      @workers = Worker.offer(created_at: "DESC").page(params[:page])
    end
  
    def show
      @worker = Worker.find_by(id: params[:id])
      @progress = Progress.new
      if @worker
        @offer = @worker.offers.new
      else
        redirect_to workers_path, alert: "worker not found."
      end
    end

    def new
      @worker = current_user.build_worker
    end
  
    def confirm
      @worker = current_user.build_worker(worker_params)
      if @worker.invalid?
        render :new
      else
        render :confirm
      end
    end
  
    def thanks
      @worker = current_user.worker || current_user.build_worker(worker_params)
      if @worker.save
        WorkerMailer.received_email(@worker).deliver
        WorkerMailer.send_email(@worker).deliver
        flash[:notice] = "送信が完了しました。"
        redirect_to root_path
      else
        flash[:alert] = "送信できませんでした。"
        render :confirm
      end
    end

    def create
      @worker = current_user.build_worker(worker_params)
      if @worker.save
        redirect_to workers_confirm_path
      else
        render 'new'
      end
    end

    def info
    end

    def offer_email
      worker = Worker.find(params[:id])
      WorkerMailer.offer_email(worker).deliver_now
      redirect_to workers_path, notice: '採用通知を送信しました'
    end
    
    def reject_email
      worker = Worker.find(params[:id])
      WorkerMailer.reject_email(worker).deliver_now
      redirect_to workers_path, notice: '不採用通知を送信しました'
    end
  
    def edit
      @worker = Worker.find(params[:id])
    end
  
    def destroy
      @worker = Worker.find(params[:id])
      @worker.destroy
      redirect_to workers_path
    end
  
    def update
      @worker = Worker.find(params[:id])
      if @worker.update(worker_params) # Strong Parametersを使用
        WorkerMailer.second_received_email(@worker).deliver
        WorkerMailer.second_send_email(@worker).deliver
        redirect_to second_thanks_workers_path
      else
        flash[:error] = @worker.errors.full_messages.to_sentence
        render 'edit'
      end
    end
  
    def import
      cnt = Worker.import(params[:file])
      redirect_to workers_url, notice:"#{cnt}件登録されました。"
    end
  
    private
    def worker_params
      params.require(:worker).permit(
        :name,
        :age,
        :email,
        :experience,
        :voice_data,
        :year,
        :commodity,
        :hope,
        :period,
        :pc,
        :start,
        :tel,
        :agree_1,
        :agree_2,
        :emergency_name,
        :emergency_relationship,
        :emergency_tel,
        :identification,
        :bank,
        :branch,
        :bank_number,
        :bank_name,
        :status
      )
    end
end
