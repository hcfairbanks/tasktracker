module UsersHelper
  def create_url
    if !current_user.nil? && current_user.is_admin?
      url = tasks_url
      msg = t('user.created')
    else
      url = root_url
      msg = t('user.pending_approval')
    end
    { 'url': url, 'msg': msg }
  end

  def destroy_url
    if !current_user.nil? && current_user.is_admin?
      url = users_url
    else
      url = root_url
    end
    { 'url': url, 'msg': t('user.destroyed') }
  end

  def destroyed_current_user?(user)
    session[:user_id] = nil if user.id == current_user.id
  end
end
