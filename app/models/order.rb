class Order < ApplicationRecord

  paginates_per 8

  belongs_to :user
  has_many :order_products, dependent: :destroy

  validates :customer_email, :total, :phone, :address, presence: true
  validates :status, inclusion: { in: %w[Pending Progress Delivered Fulfilled ] }

  before_create :set_default_status

  def set_default_status
    self.status ||= 'Pending'
  end

  def recalculate_total
    new_total = order_products.joins(:product).sum('order_products.quantity * products.price')
    update(total: new_total)
  end

  private

  def reduce_stock_if_fulfilled
    if status_changed? && status == 'Fulfilled'
      order_products.each do |order_product|
        Stock.reduce!(order_product.product_id, order_product.size, order_product.quantity)
      end
    end
  end
end
