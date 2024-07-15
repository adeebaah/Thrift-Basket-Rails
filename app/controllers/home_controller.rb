class HomeController < ApplicationController
  def index
   @main_categories = Category.all
    @slides = Slide.all
  end

  def about

  end

  def wishlist

  end
end
