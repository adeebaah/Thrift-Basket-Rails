class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy

  validates :customer_email, :total, :address, presence: true
  validates :status, inclusion: { in: %w[pending paid failed cancelled] }
end
