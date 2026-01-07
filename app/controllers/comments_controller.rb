class CommentsController < ApplicationController
  before_action :load_user
  before_action :load_comment, only: [:edit, :update, :destroy]

  def load_user
    @user = User.find(params[:user_id])
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = @user.comments.new(comment_params)

    if @comment.save
      respond_to do |format|
        format.html do
          # index 以外は従来通りリダイレクト
          redirect_to user_path(@user)
        end
        format.js do
          # index用: 最新コメントと件数を反映
          @comment_count = @user.comments.count
        end
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render js: "alert('コメントの保存に失敗しました');" }
      end
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to user_path(@user), notice: 'コメントが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to user_path(@user)
  end

  private
    def comment_params
      params.require(:comment).permit(:status, :next, :body)
    end
end
