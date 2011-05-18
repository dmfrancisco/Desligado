class ItemsController < ApplicationController
  include Timestamps # Filed under /lib/timestamps.rb

  respond_to :json # Respond with JSON objects

  def sync
    # If this is a HTTP GET request, a client want's to check for updates
    # If this is a HTTP POST, a client want's to save pending changes
    request.post? ? sync_post : sync_get
  end

  private

  def sync_get
    # Process the request
    since = from_unix_ms_timestamp params[:since]

    # Create a response
    # Should be like { "now":1279888110421, "updates": [ {"id": "F89F99F7B887423FB4B9C961C3883C0A",
    #                  "name": "Something", "_lastChange": 1279888110370 } ] }
    items = Item.updated_after(since).ordered
    items.each { |item| puts "-- Element sent: #{item.uuid}" } # Print items which must be sent
    items = items.collect{ |item| item.attributes }

    # Respond
    now  = to_unix_ms_timestamp Time.now
    resp = { "now" => now, "updates" => items }.to_json
    respond_with JSON.parse(resp.to_s)
  end

  def sync_post
    something_changed = false

    # Request body should be like [{"id":"BDDF85807155497490C12D6DA3A833F1", "name":"Something"}]
    params["_json"].each do |item_hash|
      item = Item.find_by_uuid item_hash[:id] # Checks if already exists
      item = Item.new unless item # If it's a new item, create
      item.name     = item_hash['name']
      item.category = item_hash[:category]
      item.deleted  = item_hash[:deleted]
      item.uuid     = item_hash[:id]

      something_changed ||= item.changed?
      item.save if item.changed?
      puts "-- Element synced: #{item.uuid}"
    end

    # Response should be like {"status": "ok", "now": 1279888110797}
    resp = { "status" => "ok", "now" => to_unix_ms_timestamp(Time.now) }
    respond_to do |format|
      format.json { render :json => resp.to_json }
    end
  end
end
