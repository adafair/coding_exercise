class Organization < ApplicationRecord
  has_many :events, dependent: :delete_all
  validates :name, presence: true, uniqueness: true

  DOMESTIC_TLDS = ["com", "net", "org", "gov", "edu"]

  # Query for all organizations that have had one or more foreign TLDs in the
  # hostnames for their events
  scope :foreign, -> {
    q = joins(:events)
    DOMESTIC_TLDS.each{|tld|
      q = q.where("events.hostname NOT LIKE '%.#{tld}'")
    }
    q.distinct
  }

  def as_json(options={})
    {
      name: self.name
    }
  end
end
