class Item < ActiveRecord::Base
  include Timestamps # Filed under /lib/timestamps.rb

  scope :ordered, order('updated_at desc')
  scope :updated_after, lambda { |since| where("updated_at >= ?", since) }

  attr_accessible :name, :category, :deleted

  # When updating the virtual attribute "_lastChange", update the attribute "updated_at"
  def _lastChange=(last_changed)
    # Convert from UNIX timestamp to DateTime
    write_attribute :updated_at, from_unix_ms_timestamp(last_changed)
  end

  # When reading the virtual attribute "_lastChange", read the attribute "updated_at"
  def _lastChange
    # Convert from DateTime to UNIX timestamp
    to_unix_ms_timestamp read_attribute(:updated_at)
  end

  # Override to include only the attributes we want to sync
  def attributes
    # This could be simply done like this
    # return { "id" => uuid, "name" => name, "category" => category, "_lastChange" => _lastChange,
    #   "dirty" => dirty, "deleted" => deleted }
    #
    # Follows a more generic way of doing this (doesn't rely on specific attribute names)
    hash = super.merge("_lastChange" => _lastChange, "id" => uuid ) # Add the _lastChange param
    hash.except('updated_at', 'created_at', 'uuid')
  end

  # This could be a cleaner way of doing this, but seems to corrupt element deletion
  # def id=(uuid)
  #   write_attribute :uuid, uuid
  # end
  #
  # def id
  #   read_attribute :uuid
  # end
end
