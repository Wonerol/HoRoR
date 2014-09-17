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
  name = i.xpath('name').inner_text
  flavour_text = i.xpath('flavour_text').inner_text
  cost = i.xpath('cost').inner_text
  attack = i.xpath('attack').inner_text
  defence = i.xpath('defence').inner_text
  hp = i.xpath('hp').inner_text
  min_damage = i.xpath('min_damage').inner_text
  max_damage = i.xpath('max_damage').inner_text
  speed = i.xpath('speed').inner_text

  monster = Monster.find_by(name: name)
  if !monster
    Monster.create!(name: name,
                    flavour_text: flavour_text,
                    cost: cost,
                    attack: attack,
                    defence: defence,
                    hp: hp,
                    min_damage: min_damage,
                    max_damage: max_damage,
                    speed: speed)
  else
    Monster.update_attributes(name: name,
                              flavour_text: flavour_text,
                              cost: cost,
                              attack: attack,
                              defence: defence,
                              hp: hp,
                              min_damage: min_damage,
                              max_damage: max_damage,
                              speed: speed)
  end
end
