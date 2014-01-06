class Click < ActiveRecord::Base
  belongs_to :site
  belongs_to :visitor
  belongs_to :tracking_link
  has_one :conversion
end
