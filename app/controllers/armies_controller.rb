class ArmiesController < ApplicationController

  # needs error checking!!!
=begin
when no army exists for user_id, monster_id pair -> army count increases
when army exists "" -> army count stays the same increment monster_amount
monster_amount is a reasonable number
=end
  def recruit
    @army = Army.where(user_id: params[:user_id], monster_id: params[:monster_id]).first
    success = false

    if @army.nil?
      @army = Army.new(army_params)
      success = true if @army.save
    else
      new_amount = @army.monster_amount + params[:monster_amount].to_i
      if @army.update_attribute(:monster_amount, new_amount)
        success = true 
      end
    end

    @monster = Monster.find(params[:monster_id])

    if success
      flash[:success] = "Successfully recruited #{@monster.name}"
    else
      flash[:failure] = "Failed to recruit #{@monster.name}"
    end

    redirect_to @monster
  end

  private
    def army_params
      params.permit(:user_id, :monster_id, :monster_amount)
    end
end
