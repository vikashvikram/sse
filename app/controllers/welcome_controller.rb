class WelcomeController < ApplicationController
  include ActionController::Live

  def index
    @messages = Message.all
  end
  
  def event
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 300, event: "message")
    interval = 2
    if REDIS.get(:last_id) == "" then REDIS.set(:last_id, Message.last.try(:id)) end
    last_id = REDIS.get :last_id
    unless (new_messages = Message.since_last_updated(last_id)).length.zero?
      REDIS.set(:last_id, new_messages.last.try(:id))
      sse.write(new_messages)
    end
    logger.info "sse running"
    sleep interval
  rescue IOError
    logger.info "stream is closed"
  ensure
    sse.close
  end
end
