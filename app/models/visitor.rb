class Visitor < ActiveRecord::Base
  has_many :clicks

  def name
    read_attribute(:name) || id
  end

  def most_recent_click
    clicks.order("created_at DESC").first
  end
end
