include Authorization_Helper

class ArmiesController < ApplicationController
  before_action :signed_in_user, only: [:show, :recruit, :battle]
  before_action :correct_user,   only: [:show, :recruit, :battle]
  before_action :has_army, only: [:battle]

  # Don't like having this much code here
  # loooooooooong...
  # Army, Stack, and Armies are used inconsistently...
  def battle
    enemy_army = Array.new

    if !params[:attack]
      # erase old enemy group (if any)
      wipe_old_enemy_army()

      # create an army to fight against
      enemy_army = create_wandering_monsters()

      # heal player's army
      Army.where(user_id: current_user.id, ai_controlled: false).update_all(residual_dmg: 0)
    else
      enemy_army = Army.where(user_id: current_user.id, ai_controlled: true)
    end

    # gather our forces
    player_army = Army.where(user_id: current_user.id, ai_controlled: false)

    @battle_report = nil
    if params[:attack]
      # getting code from the controller to the model
      @battle_report = resolve_combat(enemy_army.to_a, player_army.to_a)
      player_army.reload
      enemy_army.reload
    end

    @player_stacks = get_monster_stacks(player_army)
    @enemy_stacks = get_monster_stacks(enemy_army)

    @victory = false
    if @enemy_stacks.empty?
      @victory = true
      @gold_prize = rand(100) + 1

      player = User.find(current_user)
      new_gold = player.gold + @gold_prize
      player.assign_attributes({ :gold => new_gold })
      player.save(:validate => false)
    end

    if @player_stacks.empty?
      @defeat = true
    end
  end

  def show
    armies = Army.where(user_id: current_user.id, ai_controlled: false)
    @monster_stacks = get_monster_stacks(armies)
  end

  def recruit
    army = Army.where(user_id: params[:user_id], monster_id: params[:monster_id]).first
    monster = Monster.find(params[:monster_id])
    user = User.find(params[:user_id])
    num_monsters = params[:monster_amount].to_i

    if user.recruit(monster, army, army_params, num_monsters)
      flash[:success] = "Successfully recruited #{monster.name}"
    else
      flash[:failure] = "Failed to recruit #{monster.name}"
    end

    redirect_to monster
  end

  private
    def army_params
      params.permit(:user_id, :monster_id, :monster_amount, :authenticity_token)
    end

    def has_army
      if Army.where(user_id: current_user, ai_controlled: false).first.nil?
        redirect_to monsters_path(current_user), notice: "You have no army!"
      end
    end

    def get_monster_stacks(armies)
      monster_stacks = Array.new
      for army in armies
        m = Monster.find(army.monster_id)
        monster_stacks.push( {monster: m, monster_amount: army.monster_amount} )
      end
      return monster_stacks
    end

    def wipe_old_enemy_army()
      Army.where(user_id: current_user.id, ai_controlled: true).destroy_all()
    end

    # probably not the best place for this
    #============= GAME LOGIC =========================
    
    def create_wandering_monsters()
      enemy_army = Array.new
      5.times do
        monster_id = Monster.offset(rand(Monster.count)).first.id
        monster_amount = rand(1) + 1
        e_stack = Army.new(user_id: current_user.id,
                          monster_id: monster_id,
                          monster_amount: monster_amount,
                          ai_controlled: true,
                          residual_dmg: 0)
        enemy_army.push(e_stack)
      end

      ActiveRecord::Base.transaction do
        for e_stack in enemy_army
          e_stack.save
        end
      end

      return enemy_army
    end

    def calc_damage(attacker, defender)
      bonus = 0.0

      base_damage = (attacker.min_damage..attacker.max_damage).to_a.sample

      attack_diff = attacker.attack - defender.defence
      if attack_diff > 0
        bonus = base_damage * attack_diff * 0.10
      elsif attack_diff < 0
        bonus = base_damage * attack_diff * 0.05
      end

      total_damage = (base_damage + bonus).round()

      return total_damage
    end

    # simulates a full round of combat, each stack getting one turn
    # (assuming they live long enough to take it)
    def resolve_combat(enemy_army, player_army)
      pending_stacks = enemy_army + player_army
      battle_report = Array.new
      
      while !pending_stacks.empty?
        cur_report = { a_monster_name: '',
                       d_monster_name: '',
                       casualties: 0,
                       side: '',
                       damage: 0 }

        # choose a stack
        # inefficient. frivolous database calls
        # divide pending armies into priority tiers
        turn_priorities = pending_stacks.group_by { |elem| Monster.find(elem.monster_id).speed }
        # randomly choose from the highest remaining tier
        attacking_stack = turn_priorities[turn_priorities.keys.max].sample
        # choose someone for it to attack
        d_provenance = nil
        if attacking_stack.ai_controlled
          d_provenance = player_army
          cur_report[:side] = 'enemy'
        else
          d_provenance = enemy_army
          cur_report[:side] = 'player'
        end

        # defenders are all dead
        if d_provenance.empty?
          break
        end

        # choose defender at random
        defending_stack = d_provenance.sample

        # make the attack
        defending_monster = Monster.find(defending_stack.monster_id)
        attacking_monster = Monster.find(attacking_stack.monster_id)

        # calculate damage
        unit_damage = calc_damage(attacking_monster, defending_monster)
        total_damage = unit_damage * attacking_stack.monster_amount

        # determine casualties
        # either kills or doesn't, no reduced HP
        casualties = 0
        residual_dmg = 0
        if total_damage > 0
          casualties = total_damage / defending_monster.hp
          residual_dmg = total_damage % defending_monster.hp
        end

        casualties = [casualties, defending_stack.monster_amount].min

        new_num_monsters = defending_stack.monster_amount - casualties

        # file the report
        cur_report[:casualties] = casualties
        cur_report[:d_monster_name] = defending_monster.name
        cur_report[:a_monster_name] = attacking_monster.name
        cur_report[:damage] = total_damage

        # update the defender's army
        if new_num_monsters <= 0
          # destroy this army listing
          defending_stack.destroy()

          # remove from candidates
          pending_stacks.delete(defending_stack)
          d_provenance.delete(defending_stack)
        else
          defending_stack.assign_attributes({ :monster_amount => new_num_monsters, :residual_dmg => residual_dmg })
          defending_stack.save()
        end

        pending_stacks.delete(attacking_stack)
        battle_report.push(cur_report)
      end

      return battle_report
    end

end
