include Authorization_Helper

class MonstersController < ApplicationController
  before_action :signed_in_user, only: [:index, :show]

  def index
    # ORDER BY whitelist
    @sort_options = [["name ascending", "name ASC"], 
                    ["name descending", "name DESC"], 
                    ["cost ascending", "cost ASC"], 
                    ["cost descending", "cost DESC"]]
    order_by = params[:monster_order]
    unless @sort_options.include? order_by
      order_by = @sort_options[0][1]
    end

    @monsters = Monster.order(order_by).paginate(page: params[:page])

  end

  def show
    @monster = Monster.find(params[:id])
  end
end
