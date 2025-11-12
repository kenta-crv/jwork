class JobsController < ApplicationController
    def index
      @jobs = Job.order(created_at: "DESC").page(params[:page])
    end
  
    def show
      @job = Job.find(params[:id])
    end

    

    def new
      @client = Client.find(params[:client_id])
      @job = @client.jobs.new
    end

    def create
      @client = Client.find(params[:client_id])
      @client.jobs.create(job_params)
      redirect_to client_path(@client)
    end
  
    def destroy
      @client = Client.find(params[:client_id])
      @job = @client.jobs.find(params[:id])
      @job.destroy
      redirect_to client_path(@client)
    end

    def edit
      @client = Client.find(params[:client_id])
      @job = @client.jobs.find(params[:id])
    end
  
    def update
        @client = Client.find(params[:client_id])
        @job = @client.jobs.find(params[:id])
       if @job.update(job_params)
         redirect_to client_path(@client)
       else
          render 'edit'
       end
    end

    private
    def job_params
      params.require(:job).permit(
      :content,
      :working_time,
      :area,
      :purchase_price,
      :sales_price,
      :delivery,
      :payment,
      :remarks,
      :rental
      )
    end
end
