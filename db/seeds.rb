# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Admin.create(name: "Ajri", email: "ajrisylhasi@albinadyla.com", lang: "Anglisht", sending_mail: "humanresources@albinadyla.com", password: "alalalal", password_confirmation: "alalalal")
User.all.each do |u|
	u.data_fillimit ||= Date.new(Date.today.year, 1, 1)
	u.save
end
