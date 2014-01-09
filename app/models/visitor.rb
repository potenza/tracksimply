class Visitor < ActiveRecord::Base
  has_many :visits

  def name
    read_attribute(:name) || id
  end

  def most_recent_visit
    visits.order("created_at DESC").first
  end
end
