class RequestsController < ApplicationController

  before_action :get_request, only: [:accept, :complete]
  before_action :check_request, only: [:accept]
  before_action :check_ongoing_ride, only: [:accept]
  before_action :check_driver, only: [:complete]

  def driverapp
    @driver = Driver.find_by_id params[:id]
    @waiting_requests = Request.waiting.order(created_at: :desc)
    @ongoing_requests = @driver.ongoing_requests.order(created_at: :desc)
    @completed_requests = @driver.completed_requests.order(created_at: :desc)
  end

  def customerapp
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    if @request.save
      RequestBroadcastJob.perform_now(@request, "New ride created")
      redirect_to customerapp_path
    else
      flash[:alert] = @request.errors.full_messages.join(", ")
      redirect_to customerapp_path
    end
  end

  def accept
    @request.driver_id = params[:driver_id]
    @request.status = Request::REQUEST_STATUS[1][1]
    if @request.save
      AcceptRequestBroadcastJob.perform_now(@request, "Accepted")
      CompleteRequestBroadcastJob.set(wait: 5.minutes).perform_later(@request, "Completed")
      head :ok
    else
      @errors = @request.errors.full_messages.join(", ")
      respond_to :js
    end
  end

  def complete
    CompleteRequestBroadcastJob.perform_now(@request, "Completed")
    head :ok
  end

  def dashboard
    @requests = Request.all.order(created_at: :desc)
  end

  private

  def request_params
    params.require(:request).permit(:customer_id, :location)
  end

  def get_request
    @request = Request.find_by_id params[:id]
  end

  def check_request
    if @request.driver_id.present?
      flash[:alert] = "Ride is already ongoing."
      render js: "window.location = '#{driverapp_url(id: params[:driver_id])}'" and return
    end
  end

  def check_ongoing_ride
    driver = Driver.find_by_id params[:driver_id]
    if driver.ongoing_requests.present?
      flash[:alert] = "You are already on a ride."
      render js: "window.location = '#{driverapp_url(id: params[:driver_id])}'" and return
    end
  end

  def check_driver
    unless params[:driver_id].to_i == @request.driver_id
      flash[:alert] = "Sorry, You cannot complete this ride."
      render js: "window.location = '#{driverapp_url(id: params[:driver_id])}'" and return
    end
  end

end
