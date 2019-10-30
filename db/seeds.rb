# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

input_categories = [
  { name: "Baguettin Started" },
  { name: "Baguettin Crazy" },
  { name: "Baguettin Serious" },
  { name: "Beyond Baguettes" },
  { name: "Best Bread" },
  { name: "Fresh Baked" }
]

input_merchants = [
  { name: "Sea Wolf Bakers", email: "seawolf@bakers.com", nickname: "wolfy"},
  { name: "Cafe Besalu", email: "cafe@besalu.com", nickname: "cafe"},
  { name: "Macrina Bakery", email: "macrina@bakery.com", nickname: "mack"},
  { name: "Bakery Nouveau", email: "nouveau@nouveau.com", nickname: "nouv"},
]

input_products = [
  {
    name: "Flagship Baguette",
    description: "So delicious we named our site after it.",
    price: 3.95,
    photo_URL: "https://www.bakersdelight.com.au/wp-content/uploads/2018/10/9650.jpg",
    stock: 18,
    merchant_id: 1,
    categories: ["Baguettin Started", "Best Bread"]
  },
  {
    name: "Sourdough Loaf",
    description: "You think you've had better, you have not.",
    price: 5.95,
    photo_URL: "https://hostessatheart.com/wp-content/uploads/2017/10/500g-Overnight-Sourdough-Bread-Recipe-cutloaf.jpg",
    stock: 18,
    merchant_id: 2,
    categories: ["Baguettin Started"]
  },
  
  {
    name: "Thousand-layer Croissant",
    description: "Like an onion.",
    price: 3.25,
    photo_URL: "https://www.seriouseats.com/recipes/images/2011/08/20110817-166611-flour-croissants.jpg",
    stock: 24,
    merchant_id: 2,
    categories: ["Baguettin Started", "Best Bread"]
    
  },
  {
    name: "Seedy Multigrain Bread",
    description: "Seeds seeds whoa seeds.",
    price: 5.25,
    photo_URL: "http://www.mynewroots.org/site/wp-content/uploads/2013/02/bread3.jpg",
    stock: 24,
    merchant_id: 3,
    categories: ["Baguettin Crazy", "Fresh Baked"]
  },
  {
    name: "Rye Bread",
    description: "There is unfortunately no bread lorem ipsum.",
    price: 6.00,
    photo_URL: "https://www.bakefromscratch.com/wp-content/uploads/2016/08/Rye-28285-696x557.jpg",
    stock: 12,
    merchant_id: 1,
    categories: ["Baguettin Crazy", "Fresh Baked"]
  },
  {
    name: "Honey Oat Bread",
    description: "Best toast ever if you like toast.",
    price: 5.95,
    photo_URL: "https://hungryhobby.net/wp-content/uploads/2017/05/honey-oatmeal-bread-4.jpg",
    stock: 15,
    merchant_id: 3,
    categories: ["Baguettin Crazy"]
  },
  {
    name: "Bread Loafers",
    description: "Yes we're selling these.",
    price: 5.95,
    photo_URL: "https://cdn.thisiswhyimbroke.com/images/bread-loafers-300x250.jpg",
    stock: 5,
    merchant_id: 2,
    categories: ["Beyond Baguettes", "Best Bread"]
  },
  {
    name: "Loaf Cat",
    description: "Will sit under the table and match your bread.",
    price: 25.95,
    photo_URL: "https://ih0.redbubble.net/image.143625581.2463/ap,550x550,12x12,1,transparent,t.u4.png",
    stock: 2,
    merchant_id: 4,
    categories: ["Beyond Baguettes", "Fresh Baked"]
  },
  {
    name: "Daily Baguette Subscription",
    description: "The only morning routine.",
    price: 99.95,
    photo_URL: "https://d1alt1wkdk73qo.cloudfront.net/images/guide/d87ca16085d2de1e264e71d8adc125a1/640x478_ac.jpg",
    stock: 40,
    merchant_id: 1,
    categories: ["Baguettin Serious", "Best Bread"]
  },
  {
    name: "Weekend Croissant Subscription",
    description: "Stay in your pjs, they're coming to you.",
    price: 44.50,
    photo_URL: "http://res.cloudinary.com/hksqkdlah/image/upload/v1481144833/32810_sfs-croissants-14.jpg",
    stock: 40,
    merchant_id: 2,
    categories: ["Baguettin Serious", "Fresh Baked"]
  }
]


category_failures = []
input_categories.each do |input_category|
  category = Category.new(name: input_category[:name])
  successful = category.save
  if successful
    puts "Created category: #{category.inspect}"
  else
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"

merchant_failures = []
input_merchants.each do |input_merchant|
  merchant = Merchant.new(name: input_merchant[:name], email: input_merchant[:email], nickname: input_merchant[:nickname])
  successful = merchant.save
  if successful
    puts "Created merchant: #{merchant.inspect}"
  else
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

product_failures = []
input_products.each do |input_product|
  product = Product.new
  product.name = input_product[:name]
  product.description = input_product[:description]
  product.price = input_product[:price]
  product.photo_URL = input_product[:photo_URL]
  product.stock = input_product[:stock]
  product.merchant = Merchant.find_by(id: input_product[:merchant_id])
  product.active = :true 
  category_array = input_product[:categories]
  category_array.each do |input_category|
    product.categories << Category.find_by(name: input_category)
  end 
  successful = product.save
  if successful
    puts "Created product: #{product.inspect}"
  else
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"