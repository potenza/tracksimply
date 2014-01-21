class User < ActiveRecord::Base
  has_many :imports

  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
     uniqueness: true

  before_create :set_auth_token

  def to_s
    name
  end

  def admin?
    admin
  end

  def name
    "#{first_name} #{last_name}"
  end

  private

  def set_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end
end
