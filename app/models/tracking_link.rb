class TrackingLink < ActiveRecord::Base
  belongs_to :site
  has_many :clicks

  validates :site_id, presence: true
  validates :landing_page_url, presence: true
  validates :campaign, presence: true
  validates :source, presence: true
  validates :medium, presence: true
  validates :ad_content, presence: true

  before_create :set_token

  def to_s
    token
  end

  private

  def set_token
    begin
      token = SecureRandom.hex(4)
    end while TrackingLink.exists?(token: token)
    self.token = token
  end
end
