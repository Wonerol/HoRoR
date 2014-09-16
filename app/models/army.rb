class Army < ActiveRecord::Base
  belongs_to :user

  def resolve_combat(enemy_army, player_army)
    # choose a player
    losing_army = [enemy_army, player_army].sample
    player_won = losing_army == enemy_army

    # choose a stack
    losing_stack = losing_army.sample

    # calculate casualties
    casualties = 1
    new_num_monsters = losing_stack.monster_amount - casualties

    casualty_monster = Monster.find(losing_stack.monster_id)

    # update army
    if new_num_monsters <= 0
      # destroy this army listing
      losing_stack.destroy()
    else
      losing_stack.assign_attributes({ :monster_amount => new_num_monsters })
      losing_stack.save()
    end

    battle_report = { player_won: player_won, casualties: casualties, monster: casualty_monster }

    # communicate results
    return battle_report

  end

end
