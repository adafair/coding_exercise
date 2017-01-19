class Event < ApplicationRecord
  belongs_to :organization
  validates :organization, :message, :hostname, presence: true
end
