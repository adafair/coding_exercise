class Event < ApplicationRecord
  belongs_to :organization
  validates :organization, :message, :hostname, :timestamp, presence: true

  TIMESTAMP_FMT = "%Y-%m-%d %H:%M:%S"

  # Convert a timestamp string to a DateTime when assigned to this event
  def timestamp=(ts)
    if ts.kind_of? String
      begin
        ts = DateTime.strptime(ts, TIMESTAMP_FMT)
      rescue
        ts = nil
      end
    end

    self[:timestamp] = ts
  end

  # Override to output timestamp as a string in the correct format
  def as_json(options={})
    {
      id: self.id,
      message: self.message,
      hostname: self.hostname,
      timestamp: self.timestamp.strftime(TIMESTAMP_FMT)
    }
  end
end
