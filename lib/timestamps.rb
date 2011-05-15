module Timestamps
  # Converts time object to UNIX timestamp (number of milliseconds since 1970 GMT)
  def to_unix_ms_timestamp(time)
    time.to_i * 1000 # to_i gives seconds since epoch, but we want milliseconds
  end

  # Converts UNIX timestamp (number of milliseconds since 1970 GMT) to Time object
  def from_unix_ms_timestamp(string)
    Time.at string.to_i/1000 # to_i gives seconds since epoch, but we want milliseconds
  end
end
