# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Build organizations and events
10.times do |x|
  org = Organization.create(name: "Test Org #{x}")
  50.times do |y|
    org.events.create(
      message: "Test event #{y} for #{org.name}",
      hostname: "org-#{x}-host-#{(y % 2) + 1}.com", # alternates between host 1 and 2
      timestamp: DateTime.now
    )
  end
end
