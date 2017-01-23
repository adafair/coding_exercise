class Organization < ApplicationRecord
  has_many :events, dependent: :delete_all
  validates :name, presence: true, uniqueness: true

  def as_json(options={})
    {
      name: self.name
    }
  end
end
