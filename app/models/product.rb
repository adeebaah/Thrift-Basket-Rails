class Product < ApplicationRecord

  has_many_attached :images do |attachable|
    attachable.variant :medium, resize_to_limit: [250,250]
  end
  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many_attached :images
  has_many :order_products
  has_many :cart_items
  has_many :reviews, dependent: :destroy

end