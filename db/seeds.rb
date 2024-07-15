# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Slide.create([
               { title: "Get Exclusive Deals On Handbags And Purses", description: "Preloved women's bags at the cheapest prices. Grab them before they run out of stock!", image_url: ActionController::Base.helpers.asset_path("handbag.png"), link: "/handbags" },
               { title: "Women's Boots, Shoes And More", description: "Great prices, greater quality! Footwear so cheap and comfortable, you simply cannot resist!", image_url: ActionController::Base.helpers.asset_path("jeans.png"), link: "/jeans" },
               { title: "Stay Warm And Stay Fashionable", description: "Chic coats, jackets and winter wear to get you through winter, available at the best prices.", image_url: ActionController::Base.helpers.asset_path("sneakers.png"), link: "/sneakers" },
               { title: "Great Deals On Women's Pants", description: "Comfortable, affordable and stylish. Biggest bonus? You can wear them all year round!", image_url: ActionController::Base.helpers.asset_path("shirt(1).png"), link: "/shirts" }
             ])

