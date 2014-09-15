include Authorization_Helper

class MonstersController < ApplicationController
  before_action :signed_in_user, only: [:index, :show]

  def index
    @monsters = Monster.paginate(page: params[:page])
  end

  def show
    @monster = Monster.find(params[:id])
  end
end
