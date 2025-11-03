class JournalsController < ApplicationController
    def index
      @journals = Journal.order(created_at: "DESC").page(params[:page])
    end
  
    def show
      @journal = Journal.find(params[:id])
    end

    def new
      @user = User.find(params[:user_id])
      @journal = @user.journals.new
    end

    def create
      @user = User.find(params[:user_id])
      @user.journals.create(journal_params)
      redirect_to user_path(@user)
    end
  
    def destroy
      @user = User.find(params[:user_id])
      @journal = @user.journals.find(params[:id])
      @journal.destroy
      redirect_to user_path(@user)
    end

    def edit
      @user = User.find(params[:user_id])
      @journal = @user.journals.find(params[:id])
    end
  
    def update
        @user = User.find(params[:user_id])
        @journal = @user.journals.find(params[:id])
       if @journal.update(journal_params)
         redirect_to user_path(@user)
       else
          render 'edit'
       end
    end

    private
    def journal_params
      params.require(:journal).permit(
      :post,
      :dialy,
      )
    end
end
