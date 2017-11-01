class AcceptRequestBroadcastJob < ApplicationJob
  queue_as :default

  def perform(request, msg)
    ActionCable.server.broadcast "requests_channel", ongoing_partial: render_ongoing_partial(request), driver_id: request.driver_id, request_id: request.id, msg: msg
  end

  private

  def render_ongoing_partial(request)
    renderer = ApplicationController.renderer.new
    renderer.render(partial: 'requests/ongoing_request', locals: {ongoing_request: request, driver_id: request.driver_id})
  end
end
