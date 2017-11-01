class CompleteRequestBroadcastJob < ApplicationJob
  queue_as :default

  def perform(request, msg)
    if request.is_ongoing?
      request.update_columns(status: Request::REQUEST_STATUS[2][1], completed_at: Time.now.utc)
      ActionCable.server.broadcast "requests_channel", completed_partial: render_completed_partial(request), driver_id: request.driver_id, request_id: request.id, msg: msg
    end
  end

  private

  def render_completed_partial(request)
    renderer = ApplicationController.renderer.new
    renderer.render(partial: 'requests/completed_request', locals: {completed_request: request})
  end
end
