puts "Seeds: Start"

puts "Create: Users"
User.create(email: "example@example.com", password: "secret")
User.create(email: "user@user.com", password: "user123")

puts "Create: Wishlists"
6.times do
  Wishlist.create(
    name: Faker::Lorem.sentence(2),
    description: Faker::Lorem.paragraph,
    user: User.all.sample
  )
end

puts "Create: Items"
20.times do
  Item.create(
    name: Faker::Lorem.sentence(2),
    description: Faker::Lorem.paragraph,
    wishlist: Wishlist.all.sample
  )
end

puts "Seeds: Stop"
