module Authorization_Helper

  # authorization stuff
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    authorization_param = params[:user_id]
    authorization_param ||= params[:id]
    @user = User.find(authorization_param)
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
