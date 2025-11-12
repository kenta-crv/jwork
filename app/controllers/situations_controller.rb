class SituationsController < ApplicationController
    before_action :load_client
    before_action :load_situation, only: [:edit,:update,:show,:destroy]
    #before_action :authenticate_client!

    def load_client
      @client = Client.find(params[:client_id])
      @situation = Situation.new
    end

    def load_situation
      @situation = Situation.find(params[:id])
    end

    def edit
    end

    def create
      @situation = @client.situations.new(situation_params)
      if @situation.save
        redirect_to client_path(@client)
      else
        logger.debug @situation.errors.full_messages
        # 適切なエラー処理（例: フォームを再表示するなど）
      end
    end

  	def destroy
  		@client = Client.find(params[:client_id])
  		@situation = @client.situations.find(params[:id])
  		@situation.destroy
  		redirect_to client_path(@client)
  	end

  	 def update
      @situation = Situation.find(params[:client_id])
      @situation = @client.situations.find(params[:id])
      if @situation.update(situation_params)
         redirect_to client_path(@client)
      else
          render 'edit'
      end
    end

    private
   	def situation_params
   		params.require(:situation).permit(
       :status,
       :next,
       :body,
      )
   	end

end
