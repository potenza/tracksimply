require 'csv'

class Import < ActiveRecord::Base
  ImportRow = Struct.new(:token, :date, :cost)

  belongs_to :site
  belongs_to :user
  belongs_to :import_format
  has_many :expenses, dependent: :destroy

  mount_uploader :file, FileUploader

  validates :file, presence: true

  before_create :set_default_name
  after_commit :spawn_worker, on: [:create, :update]

  def to_s
    name
  end

  def processed?
    !processed_at.nil?
  end

  def first_line
    csv.first
  end

  def preview
    csv[0,10]
  end

  def file_name
    File.basename(file.path)
  end

  def first_date
    dates.min
  end

  def last_date
    dates.max
  end

  def total
    expenses.sum(:amount)
  end

  def process!
    return if import_format.nil? || processed?
    rows.each do |row|
      tracking_link = site.tracking_links.where(token: row.token).first
      tracking_link.overwrite_expenses_for_date(id, row.date, row.cost) if tracking_link
    end
    processed!
  end

  private

  def csv
    @csv ||= CSV.parse(file.read)
  end

  def dates
    @dates ||= expenses.pluck(:paid_at)
  end

  def processed!
    update_attributes(
      name: "#{import_format.file_type} Import",
      processed_at: Time.now
    )
  end

  def parse_token(url)
    return unless url
    match = url.match(/\/r\/([A-Z0-9]{6})/i)
    match && match[1]
  end

  def parse_date(date)
    Chronic.parse(date).in_time_zone(Rails.application.config.time_zone).beginning_of_day
  end

  def rows
    csv.map.with_index do |line, i|
      begin
        token = parse_token(line[import_format.url_column])
        if token
          date = parse_date(line[import_format.date_column])
          cost = line[import_format.cost_column].to_f
          ImportRow.new(token, date, cost)
        end
      end
    end.compact # remove nils (lines where a token couldn't be parsed)
  end

  def set_default_name
    self.name = "Import"
  end

  def spawn_worker
    ImportWorker.perform_async(id)
  end
end
