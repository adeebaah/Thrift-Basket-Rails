class SlidesController < ApplicationController
  def index
    @slides = Slide.all
    @main_categories = Category.all
  end
end
