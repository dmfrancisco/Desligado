# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # Send ping to all clients, notifying them to sync
  def broadcast_ping
    broadcast '/sync', 'ping'
  end

  # Broadcast a message to all clients (only used by broadcast_ping)
  def broadcast(channel, data)
    message = { :channel => channel, :data => data }
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end
