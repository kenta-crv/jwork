class InspectionsController < ApplicationController
    def index
      @inspections = Inspection.order(created_at: "DESC").page(params[:page])
    end
  
    def show
      @inspection = Inspection.find(params[:id])
    end

    

    def new
      @user = User.find(params[:user_id])
      @inspection = @user.inspections.new
    end

    def create
      @user = User.find(params[:user_id])
      @user.inspections.create(inspection_params)
      redirect_to user_path(@user)
    end
  
    def destroy
      @user = User.find(params[:user_id])
      @inspection = @user.inspections.find(params[:id])
      @inspection.destroy
      redirect_to user_path(@user)
    end

    def edit
      @user = User.find(params[:user_id])
      @inspection = @user.inspections.find(params[:id])
    end
  
    def update
        @user = User.find(params[:user_id])
        @inspection = @user.inspections.find(params[:id])
       if @inspection.update(inspection_params)
         redirect_to user_path(@user)
       else
          render 'edit'
       end
    end

    private
    def inspection_params
      params.require(:inspection).permit(
      :post,
      :brakes,
      :steering,
      :tires,
      :lighting,
      :battely,
      :engine,
      :coolant,
      :wiper,
      :exhaust,
      :underbody,
      :remarks
      )
    end
end
