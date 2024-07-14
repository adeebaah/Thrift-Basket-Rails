class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :cart, dependent: :destroy
  after_create :create_cart
  has_one :wishlist, dependent: :destroy
  after_create :initialize_wishlist



  def create_cart
    Cart.create(user: self)
  end
  def create_wishlist
    Wishlist.create(user: self)
  end
  def initialize_wishlist
    create_wishlist unless wishlist
  end




  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
