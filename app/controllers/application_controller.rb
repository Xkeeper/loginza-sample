class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :logged_in?, :current_user

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= (login_from_cookie) unless @current_user==false
  end

  def current_user=(authuser)
    session[:user_id] = authuser ? authuser.id : nil
    @current_user = authuser || false
  end

  def login_from_cookie
    user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      self.current_user = user
    end
  end

  def valid_remember_cookie?
    return nil unless @current_user
    (@current_user.remember_token?) &&
        (cookies[:auth_token] == @current_user.remember_token)
  end

  def handle_remember_cookie!(new_cookie_flag)
    return unless @current_user
      case
        when valid_remember_cookie? then @current_user.refresh_token
        when new_cookie_flag then @current_user.remember_me
        else @current_user.forget_me
      end
    send_remember_cookie!
  end

  def send_remember_cookie!
    cookies[:auth_token] = {
        :value => @current_user.remember_token,
        :expires => @current_user.remember_token_expires_at
    }
  end

end
