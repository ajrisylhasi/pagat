# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Admin.create(name: "IT Department", email: "itdepartment@albinadyla.com", lang: "Anglisht", sending_mail: "humanresources@albinadyla.com", password: "albinadyla2020", password_confirmation: "albinadyla2020")
# User.all.each do |u|
# 	if u.idnum.include? "IDGJ"
#       u.place = "Gjakove"
#     elsif u.idnum.include? "IDFK"
#       u.place = "Prishtine"
#     else
#       u.place = "Gjakove"
#     end
#     u.save
# end
admin = Admin.find_by(name: "IT Department")
admin.password = "albinadyla2020"
admin.password_confirmation = "albinadyla2020"
admin.save
