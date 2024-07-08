class Stock < ApplicationRecord
  belongs_to :product

  def self.available?(product_id, size)
    stock = where(product_id: product_id, size: size).first
    stock && stock.amount > 0
  end

  def self.reduce!(product_id, size, quantity)
    stock = find_by(product_id: product_id, size: size)
    stock.amount -= quantity
    stock.save!
  end

  def self.increase!(product_id, size, quantity)
    stock = find_by(product_id: product_id, size: size)
    stock.amount += quantity
    stock.save!
  end
end
