class Product < ApplicationRecord
  paginates_per 8

  attribute :visible, :boolean, default: true

  has_many_attached :images do |attachable|
    attachable.variant :medium, resize_to_limit: [250,250]
  end
  belongs_to :category
  has_many :stocks, dependent: :destroy
  has_many_attached :images
  has_many :order_products
  has_many :cart_items
  has_many :reviews, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wishlist_items, dependent: :destroy

  # # Rating
  # def bayesian_average_rating
  #   m = Product.average_product_rating || 3.5
  #   c = Product.calculate_c
  #
  #   product_ratings_avg = reviews.average(:rating)  || 0
  #   product_ratings_count = reviews.count
  #
  #   bayesian_avg = (product_ratings_avg * product_ratings_count + c * m) / (product_ratings_count + c)
  #   bayesian_avg.round(2) # rounding to 2 decimal places for display
  # end
  #
  # # this is m -->
  # def self.average_product_rating
  #   joins(:reviews).average(:rating).to_f
  # end
  #
  # def self.calculate_c
  #   product_ratings_counts = Product.joins(:reviews).group(:id).count.values
  #   sorted_counts = product_ratings_counts.sort
  #   quartile_index = (sorted_counts.length * 0.25).ceil - 1
  #   sorted_counts[quartile_index] || 0
  # end


end