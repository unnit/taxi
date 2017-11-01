class RequestBroadcastJob < ApplicationJob
  queue_as :default

  def perform(request, msg)
    ActionCable.server.broadcast "requests_channel", waiting_partial: render_waiting_partial(request), request_id: request.id, msg: msg
  end

  private

  def render_waiting_partial(request)
    renderer = ApplicationController.renderer.new
    renderer.render(partial: 'requests/waiting_request', locals: {waiting_request: request, driver_id: ""})
  end
end
