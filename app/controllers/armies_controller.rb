include Authorization_Helper

class ArmiesController < ApplicationController
  before_action :signed_in_user, only: [:show, :recruit]
  before_action :correct_user,   only: [:show, :recruit]

  def show
    armies = Army.where(user_id: current_user.id)
    @monster_stacks = Array.new
    for army in armies
      m = Monster.find(army.monster_id)
      @monster_stacks.push( {monster: m, monster_amount: army.monster_amount} )
    end
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
      params.permit(:user_id, :monster_id, :monster_amount)
    end
end
