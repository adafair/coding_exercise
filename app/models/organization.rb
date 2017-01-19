class Organization < ApplicationRecord
  has_many :events, dependent: :delete_all
  validates :name, presence: true, uniqueness: true
end
