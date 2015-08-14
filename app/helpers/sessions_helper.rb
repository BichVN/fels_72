module SessionsHelper
  def log_in user 
    session[:user_id] = user.id
  end
  
  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete :user_id
    @current_user = nil
  end

  def current_user? user
    user == current_user
  end

  def verify_admin?
    unless logged_in? && current_user.admin?
      flash[:danger] = t "permission_warning"
      redirect_to login_url
    end
  end

  def gravatar_for user
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
end
