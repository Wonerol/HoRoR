include Authorization_Helper

class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def destroy
    found_user = User.find(params[:id])
    if found_user != current_user
      found_user.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    else
      flash[:failure] = "Cannot delete yourself."
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

=begin
  def show_army
    armies = Army.where(user_id: current_user.id)
    @monster_stacks = Array.new
    for army in armies
      m = Monster.find(army.monster_id)
      @monster_stacks.push( {monster: m, monster_amount: army.monster_amount} )
    end
  end
=end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to HoRoR!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
