class OrderProduct < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :size, :quantity, presence: true
end
