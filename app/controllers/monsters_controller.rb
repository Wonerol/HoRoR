class MonstersController < ApplicationController
  def index
    @monsters = Monster.paginate(page: params[:page])
  end

  def show
    @monster = Monster.find(params[:id])
  end
end
