class ImportFormat < ActiveRecord::Base
  has_many :imports

  validates :file_type, presence: true
  validates :date_column, presence: true
  validates :url_column, presence: true
  validates :cost_column, presence: true
end
