class ProgressesController < ApplicationController
    def create
      @user = User.find(params[:user_id])
      @progress = @user.progresses.new(progress_params)
      
      if @progress.save
        UserMailer.new_progress_notification(@progress).deliver_now
        redirect_to user_path(@user), notice: 'コメントを更新しました。'
      else
        render :new
      end
    end
    
    def edit
      @user = User.find(params[:user_id])
      @progress = Progress.find(params[:id])
    end
  
      def destroy
          @user = User.find(params[:user_id])
          @progress = @user.progresses.find(params[:id])
          @progress.destroy
          redirect_to user_path(@user)
      end
  
    def update
      @user = User.find(params[:user_id])
      @progress = @user.progresses.find(params[:id])
      if @progress.update(progress_params)
         redirect_to user_path(@user)
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
  