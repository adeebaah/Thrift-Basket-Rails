class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy

  validates :customer_email, :total, :phone, :address, presence: true
  validates :status, inclusion: { in: %w[Pending Fulfilled   ] }

  before_create :set_default_status
  def set_default_status
    self.status ||= 'Pending'
  end
end
