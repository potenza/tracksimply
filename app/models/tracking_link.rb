class TrackingLink < ActiveRecord::Base
  belongs_to :site
  has_many :visits
  has_many :conversions, through: :visits
  has_many :expenses
  has_one :cost

  accepts_nested_attributes_for :cost, allow_destroy: true

  MEDIA = ['Paid Search', 'Social Media', 'Email', 'Mobile', 'Blogs',
             'Classifieds', 'Press Release', 'Referral',
             'Display Ads (Banner Ads)', 'Other']

  validates :site_id, presence: true
  validates :landing_page_url, presence: true,
    format: { with: /\Ahttps?:\/\/.+/i, message: "Invalid URL. Example: http://www.google.com" }
  validates :campaign, presence: true
  validates :source, presence: true
  validates :medium, presence: true,
    inclusion: { within: MEDIA }
  validates :ad_content, presence: true

  before_create :set_token

  def to_s
    token
  end

  def process_new_visit(visit)
    amount = cost && cost.visit_cost
    if amount > 0
      expenses.create(
        visit: visit,
        amount: amount,
        paid_at: Time.now
      )
    end
  end

  private

  def set_token
    begin
      token = SecureRandom.hex(3)
    end while TrackingLink.exists?(token: token)
    self.token = token
  end
end
