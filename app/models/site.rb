class Site < ActiveRecord::Base
  has_many :tracking_links
  has_many :clicks
  has_many :conversions, through: :clicks

  validates :name, presence: true

  def to_s
    name
  end
end
