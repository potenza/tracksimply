class Conversion < ActiveRecord::Base
  belongs_to :visit
  has_one :tracking_link, through: :visit
end
