class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :cart, dependent: :destroy
  after_create :create_cart
  has_one :wishlist, dependent: :destroy
  after_create :initialize_wishlist

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must contain @" }
  validates :phone, presence: true, length: { is: 11, message: "Must be 11 digits long" }, unless: :oauth_signup?
  validates :address, presence: true, length: { minimum: 5, message: "Must be at least 5 characters long" }, unless: :oauth_signup?
  validate :password_complexity, unless: :oauth_signup?

  def create_cart
    Cart.create(user: self)
  end

  def create_wishlist
    Wishlist.create(user: self)
  end

  def initialize_wishlist
    create_wishlist unless wishlist
  end

  private

  def oauth_signup?
    provider.present? && uid.present?
  end

  def password_complexity
    return if password.blank?

    unless password =~ /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])/
      errors.add :password, 'must include at least one uppercase letter, one lowercase letter, one digit, and one special character (!@#$%^&*).'
    end

    unless password.length >= 8
      errors.add :password, 'must be at least 8 characters long.'
    end
  end
end
