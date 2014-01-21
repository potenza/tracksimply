class Expense < ActiveRecord::Base
  belongs_to :tracking_link
  belongs_to :visit
  belongs_to :import
end
