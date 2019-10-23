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
]

input_merchants = [
  { username: "Sea Wolf Bakers" },
  { username: "Cafe Besalu" },
  { username: "Macrina Bakery" },
  { username: "Bakery Nouveau" },
]

input_products = [
  {
    name: "Flagship Baguette",
    description: "So delicious we named our site after it.",
    price: 3.95,
    photo_url: "https://flic.kr/p/6hQm3a",
    stock: 18,
    merchant: "Sea Wolf Bakers",
    category: "Baguettin Started"
  },
  {
    name: "Sourdough Loaf",
    description: "You think you've had better, you have not.",
    price: 5.95,
    photo_url: "https://flic.kr/p/2dH8ZwL",
    stock: 18,
    merchant: "Besalu Bakery",
    category: "Baguettin Started"
  },

  {
    name: "Thousand-layer Croissant",
    description: "Like an onion.",
    price: 3.25,
    photo_url: "https://flic.kr/p/2gjNUvW",
    stock: 24,
    merchant: "Cafe Besalu",
    category: "Baguettin Started"

  },
  {
    name: "Seedy Multigrain Bread",
    description: "Seeds seeds whoa seeds.",
    price: 5.25,
    photo_url: "https://flic.kr/p/c4w5oq",
    stock: 24,
    merchant: "Macrina Bakery",
    category: "Baguettin Crazy"
  },
  {
    name: "Rye Bread",
    description: "There is unfortunately no bread lorem ipsum.",
    price: 6.00,
    photo_url: "https://flic.kr/p/RziS2m",
    stock: 12,
    merchant: "Sea Wolf Bakers",
    category: "Baguettin Crazy"
  },
  {
    name: "Honey Oat Bread",
    description: "Best toast ever if you like toast.",
    price: 5.95,
    photo_url: "https://flic.kr/p/26HVUyc",
    stock: 15,
    merchant: "Macrina Bakery",
    category: "Baguettin Crazy"
  },
  {
    name: "Bread Loafers",
    description: "Yes we're selling these.",
    price: 5.95,
    photo_url: "https://flic.kr/p/4fj4jg",
    stock: 5,
    merchant: "Cafe Besalu",
    category: "Beyond Baguettes"
  },
  {
    name: "Loaf Cat",
    description: "Will sit under the table and match your bread.",
    price: 25.95,
    photo_url: "https://flic.kr/p/nCyCR",
    stock: 2,
    merchant: "Bakery Nouveau",
    category: "Beyond Baguettes"
  },
  {
    name: "Daily Baguette Subscription",
    description: "The only morning routine.",
    price: 99.95,
    photo_url: "https://flic.kr/p/6DYNFH",
    stock: 40,
    merchant: "Sea Wolf Bakers",
    category: "Baguettin Serious"
  },
  {
    name: "Weekend Croissant Subscription",
    description: "Stay in your pjs, they're coming to you.",
    price: 44.50,
    photo_url: "https://flic.kr/p/3ZFxkg",
    stock: 40,
    merchant: "Cafe Besalu",
    category: "Baguettin Serious"
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
  merchant = Merchant.new(name: input_merchant[:name])
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
  product.photo_url = input_product[:photo_url]
  product.publication_date = input_product[:publication_date]
  product.stock = input_product[:stock]
  product.merchant = Merchant.find_by(name: input_product[:merchant])
  product.category = Category.find_by(name: input_product[:category])
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