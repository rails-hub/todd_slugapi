# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:has_challenge_mode=>true, :has_sharing=>true,:username=>'opponent',:password=>'Password00',:email=>'jquave+c@gmail.com', :device_token=>'123abc456dee')
User.create(:has_challenge_mode=>true, :has_sharing=>true,:username=>'jquave',:password=>'Password00',:email=>'jquave@gmail.com', :device_token=>'123abc456def')
