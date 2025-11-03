class AlcoholsController < ApplicationController
    def index
      @alcohols = Alcohol.order(created_at: "DESC").page(params[:page])
    end
  
    def show
      @alcohol = Alcohol.find(params[:id])
    end

    

    def new
      @user = User.find(params[:user_id])
      @alcohol = @user.alcohols.new
    end

    def create
      @user = User.find(params[:user_id])
      @user.alcohols.create(alcohol_params)
      redirect_to user_path(@user)
    end
  
    def destroy
      @user = User.find(params[:user_id])
      @alcohol = @user.alcohols.find(params[:id])
      @alcohol.destroy
      redirect_to user_path(@user)
    end

    def edit
      @user = User.find(params[:user_id])
      @alcohol = @user.alcohols.find(params[:id])
    end
  
    def update
        @user = User.find(params[:user_id])
        @alcohol = @user.alcohols.find(params[:id])
       if @alcohol.update(alcohol_params)
         redirect_to user_path(@user)
       else
          render 'edit'
       end
    end

    private
    def alcohol_params
      params.require(:alcohol).permit(
      :post,
      :check,
      :health,
      )
    end
end
