class CommentsController < ApplicationController
    before_action :load_user
    before_action :load_comment, only: [:edit,:update,:show,:destroy]
    #before_action :authenticate_user!

    def load_user
      @user = User.find(params[:user_id])
      @comment = Comment.new
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end


    def create
      @comment = @user.comments.new(comment_params)
      if @comment.save
        redirect_to user_path(@user)
      else
        logger.debug @comment.errors.full_messages
        # 適切なエラー処理（例: フォームを再表示するなど）
      end
    end

  def edit
    @user = User.find(params[:user_id])
    @comment = @user.comments.find(params[:id])
  end
  
  def destroy
    @user = User.find(params[:user_id])
    @comment = @user.comments.find(params[:id])
    @comment.destroy
    redirect_to user_path(@user)
  end

  def update
    @user = User.find(params[:user_id])
    @comment = @user.comments.find(params[:id])
    if @comment.update(comment_params)
      redirect_to user_path(@user), notice: 'コメントが更新されました。'
    else
      render :edit
    end
  end

  private
   	def comment_params
   		params.require(:comment).permit(
       :status,
       :next,
       :body,
      )
   	end

end
