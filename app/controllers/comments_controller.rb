class CommentsController < ApplicationController
    before_action :load_client
    before_action :load_comment, only: [:edit,:update,:show,:destroy]
    #before_action :authenticate_user!

    def load_client
      @client = Client.find(params[:client_id])
      @comment = Comment.new
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end

    def edit
    end

    def create
      @comment = @client.comments.new(comment_params)
      if @comment.save
        redirect_to client_path(@client)
      else
        logger.debug @comment.errors.full_messages
        # 適切なエラー処理（例: フォームを再表示するなど）
      end
    end

  	def destroy
  		@client = Client.find(params[:client_id])
  		@comment = @client.comments.find(params[:id])
  		@comment.destroy
  		redirect_to client_path(@client)
  	end

  	 def update
      @comment = Comment.find(params[:client_id])
      @comment = @client.comments.find(params[:id])
      if @comment.update(comment_params)
         redirect_to client_path(@client)
      else
          render 'edit'
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
