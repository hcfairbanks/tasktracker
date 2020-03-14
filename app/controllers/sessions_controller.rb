class SessionsController < ApplicationController

  def new
  end

  def build_msg
    base_msg = nil
    if user = User.find_by(email: params[:email])
      if user.role.name != Role::UNASSIGNED && user.role.name != Role::DEACTIVATED 
        base_msg = check_pw(user)
      else
        base_msg = t('session.unassigned')
      end
    else
      base_msg = t('session.invalid')
    end
    base_msg
  end

  def check_pw(user)
    check_pw_msg = nil
    if user.authenticate(params[:password]) &&
       user.login_attempts < User::LOGIN_ATTEMPTS_MAX
      check_pw_msg = t('session.logged_in')
    else
      check_pw_msg = how_may_tries_left(user)
    end
    check_pw_msg
  end

  def how_may_tries_left(user)
    tries_msg = nil
    user.login_attempts += 1
    attempts_left = User::LOGIN_ATTEMPTS_MAX - user.login_attempts
    user.save!
    if attempts_left == 0
      tries_msg = t('session.locked_out')
    else
      tries_msg = attempts_left.to_s + t('session.attempts_left')
    end
    tries_msg
  end

  def create
    msg = build_msg
    if msg == t('session.logged_in')
      user = User.find_by(email: params[:email])
      user.login_attempts = 0
      user.save!
      session[:user_id] = user.id
      redirect_to tasks_url, notice: msg and return
    else
      flash.now.alert = msg
      render :new
    end
  end

  def destroy
    msg = session[:user_id] == nil ? nil : t('session.logged_out')
    session[:user_id] = nil
    redirect_to root_url, notice: msg
  end
end
