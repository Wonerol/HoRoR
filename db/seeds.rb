# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Add monsters... via XML!
f = File.open(File.join(Rails.root, 'db', "monster_seed.xml"))
doc = Nokogiri::XML(f)

doc.xpath('//monster').map do |i|
  monster_name = i.xpath('name').inner_text
  if !Monster.find_by(name: monster_name)
    Monster.create!(name: monster_name,
                    flavour_text: i.xpath('flavour_text').inner_text)
  end
end
