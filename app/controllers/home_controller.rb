class HomeController < ApplicationController
  def index
   @main_categories = Category.take(4)
  end

  def about

  end

  def wishlist

  end
end
