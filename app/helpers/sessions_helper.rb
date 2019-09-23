module SessionsHelper

  # Logs a user in
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Checks whether a user is the currently logged in user
  def current_user?(user)
    user == current_user
  end

  # Returns the currently logged in user
  def current_user
    user_id = session[:user_id]
    if user_id
      @current_user ||= User.find_by(id: user_id)
      return @current_user
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        @current_user = user
        log_in @current_user
        return @current_user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    @current_user = nil
    session.delete(:user_id)
  end
end