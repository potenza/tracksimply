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
  validates :medium, presence: true,
    inclusion: { within: MEDIA }
  validates :landing_page_url, presence: true,
    format: { with: /\Ahttps?:\/\/.+/i, message: "Invalid URL. Example: http://www.google.com" }
  validates :campaign, presence: true
  validates :source, presence: true
  validates :ad_content, presence: true

  before_create :set_token
  after_create :spawn_worker

  def to_s
    token
  end

  def process_new_visit(visit)
    amount = cost && cost.visit_cost
    if amount
      expenses.create(
        visit: visit,
        amount: amount,
        paid_at: Time.now
      )
    end
  end

  def generate_expense_records
    pending_expenses.each do |pending_expense|
      expenses.create(
        amount: pending_expense.amount,
        paid_at: pending_expense.date
      )
    end
  end

  private

  def pending_expenses
    cost && PendingExpenseFinder.new(cost.charges, expenses).find || []
  end

  def set_token
    begin
      token = SecureRandom.hex(3)
    end while TrackingLink.exists?(token: token)
    self.token = token
  end

  def spawn_worker
    TrackingLinkWorker.perform_async(id)
  end
end
