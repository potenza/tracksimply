class Site < ActiveRecord::Base
  has_many :tracking_links
  has_many :visits
  has_many :conversions, through: :visits

  validates :name, presence: true

  def to_s
    name
  end
end
