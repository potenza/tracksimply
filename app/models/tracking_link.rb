class TrackingLink < ActiveRecord::Base
  belongs_to :site
  has_many :visits
  has_many :conversions, through: :visits
  has_many :expenses
  has_one :cost
  delegate :charges, to: :cost

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
  after_commit :spawn_worker, on: :create

  def to_s
    token
  end

  def process_new_visit(visit)
    amount = cost && cost.visit_cost
    if amount
      expenses.create(
        visit: visit,
        paid_at: Time.zone.now.beginning_of_day,
        amount: amount
      )
    end
  end

  def overwrite_expenses_for_date(import_id, paid_at, amount)
    expenses.where(paid_at: paid_at).destroy_all
    expenses.create(
      import_id: import_id,
      paid_at: paid_at,
      amount: amount
    )
  end

  def generate_expense_records
    pending_expenses.each do |pending_expense|
      expenses.create(
        paid_at: pending_expense.datetime,
        amount: pending_expense.amount
      )
    end
  end

  private

  def pending_expenses
    return [] unless cost

    # return an array of charges that don't have a matching expense record
    charges.find_all do |charge|
      expenses.where(paid_at: charge.datetime).count == 0
    end
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
