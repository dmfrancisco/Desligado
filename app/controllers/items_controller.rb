class ItemsController < ApplicationController
  include Timestamps # Filed under /lib/timestamps.rb

  respond_to :json # Respond with JSON objects

  def index
    respond_with Item.ordered.all
  end

  def sync
    # If this is a HTTP GET request, a client want's to check for updates
    # If this is a HTTP POST, a client want's to save pending changes
    request.post? ? sync_post : sync_get
  end

  def show
    respond_with Item.find(params[:id])
  end

  def create
    respond_with Item.create!(params)
  end

  def update
    item = Item.find(params[:id])
    item.update_attributes! params
    respond_with item
  end

  private

  def sync_get
    # Process the request
    since = from_unix_ms_timestamp params[:since]

    # Create a response
    # Should be like { "now":1279888110421, "updates": [ {"id": "F89F99F7B887423FB4B9C961C3883C0A",
    #                  "name": "Something", "_lastChange": 1279888110370 } ] }
    items = Item.updated_after(since).ordered
    items = items.collect{ |item| item.attributes }
    puts items.to_yaml # Print the new items which must be sent

    # Respond
    now  = to_unix_ms_timestamp Time.now
    resp = { "now" => now, "updates" => items }.to_json
    respond_with JSON.parse(resp.to_s)
  end

  def sync_post
    # Request body should be like [{"id":"BDDF85807155497490C12D6DA3A833F1", "name":"Something"}]
    params["_json"].each do |item_hash|
      item = Item.find_by_uuid item_hash[:id] # Checks if already exists
      item = Item.new unless item # If it's a new item, create
      item.name     = item_hash['name']
      item.category = item_hash[:category]
      item.deleted  = item_hash[:deleted]
      item.uuid     = item_hash[:id]
      item.save
    end

    # Response should be like {"status": "ok", "now": 1279888110797}
    resp = { "status" => "ok", "now" => to_unix_ms_timestamp(Time.now) }
    respond_to do |format|
      format.json { render :json => resp.to_json }
    end
  end
end
