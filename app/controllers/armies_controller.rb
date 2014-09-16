include Authorization_Helper

class ArmiesController < ApplicationController
  before_action :signed_in_user, only: [:show, :recruit, :battle]
  before_action :correct_user,   only: [:show, :recruit, :battle]
  before_action :has_army, only: [:battle]

  # Don't like having this much code here
  def battle
    enemy_army = Array.new
    if !params[:attack]
      # erase old enemy group (if any)
      wipe_old_enemy_army()

      # create an army to fight against
      enemy_army = create_wandering_monsters()
    else
      enemy_army = Army.where(user_id: current_user.id, ai_controlled: true)
    end

    # gather our forces
    player_army = Army.where(user_id: current_user.id, ai_controlled: false)

    if params[:attack]
      battle_report = enemy_army.first.resolve_combat(enemy_army, player_army)
      casualties = battle_report[:casualties]
      losing_monster = battle_report[:monster]

      if battle_report[:player_won]
        flash[:success] = "Yay! defeated #{casualties} #{losing_monster.name}"
      else
        flash[:failure] = "Oh no! lost #{casualties} #{losing_monster.name}"
      end

      player_army.reload
      enemy_army.reload
    end

    @player_stacks = get_monster_stacks(player_army)
    @enemy_stacks = get_monster_stacks(enemy_army)
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

    # move to model?
    def create_wandering_monsters()
      enemy_army = Array.new
      1.times do
        monster_id = Monster.offset(rand(Monster.count)).first.id
        monster_amount = rand(1) + 1
        e_stack = Army.new(user_id: current_user.id,
                          monster_id: monster_id,
                          monster_amount: monster_amount,
                          ai_controlled: true)
        enemy_army.push(e_stack)
      end

      ActiveRecord::Base.transaction do
        for e_stack in enemy_army
          e_stack.save
        end
      end

      return enemy_army
    end

end
