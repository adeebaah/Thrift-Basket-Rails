class Product < ApplicationRecord
  belongs_to :category
  has_many :stocks
  has_many_attached :images

end