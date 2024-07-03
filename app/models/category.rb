class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [200,200]
  end

end