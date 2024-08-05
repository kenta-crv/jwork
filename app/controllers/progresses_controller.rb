class ProgressesController < ApplicationController
    def create
      @worker = Worker.find(params[:worker_id])
      @progress = @worker.progresses.new(progress_params)
      
      if @progress.save
        WorkerMailer.new_progress_notification(@progress).deliver_now
        redirect_to worker_path(@worker), notice: 'コメントを更新しました。'
      else
        render :new
      end
    end
    
  
    def edit
      @worker = Worker.find(params[:worker_id])
      @progress = Progress.find(params[:id])
    end
  
      def destroy
          @worker = Worker.find(params[:worker_id])
          @progress = @worker.progresses.find(params[:id])
          @progress.destroy
          redirect_to worker_path(@worker)
      end
  
    def update
      @worker = Worker.find(params[:worker_id])
      @progress = @worker.progresses.find(params[:id])
      if @progress.update(progress_params)
         redirect_to worker_path(@worker)
      else
          render 'edit'
      end
    end
  
    private
    def progress_params
       params.require(:progress).permit(
          :status,
          :next,
          :body,
      )
    end
  end
  