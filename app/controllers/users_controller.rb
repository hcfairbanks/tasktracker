class UsersController < ApplicationController
  include ReadableErrors
  include UsersHelper
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit,
                                  :update, :destroy,
                                  :serve_small,
                                  :serve_medium,
                                  :serve_large,
                                  :reset_pw_attempts]

  def reset_login_attempts
    @user.login_attempts = 0
    @user.save!
    redirect_to @user, notice: t('user.login_attempts_reset')
  end

  def serve_small
    send_file(@user.avatar.small_path, disposition: 'inline', x_sendfile: true)
  end

  def serve_medium
    send_file(@user.avatar.medium_path, disposition: 'inline', x_sendfile: true)
  end

  def serve_large
    send_file(@user.avatar.large_path, disposition: 'inline', x_sendfile: true)
  end

  def index
    @users = User.all.where.not(email: User::UNASSIGNED_USER)
    @users = @users.filter_like(params.slice(:first_name,:last_name,:email))
    @users = @users.filter_exact(params.slice(:role))
    @users = @users.order(params[:order_by]) if !params[:order_by].blank?
    @users = @users.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if verify_recaptcha(model: @user) && @user.save
      redirect_to create_url[:url], notice: create_url[:msg]
    else
      render :new, alert: formated_errors(@user)
    end
  end

  def update
    if @user.update(pw_present(user_params))
      redirect_to @user, notice: t('user.updated')
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      destroyed_current_user?(@user)
      redirect_to destroy_url[:url], notice: destroy_url[:msg]
    else
      render :new, alert: formated_errors(@user)
    end
  end

  def destroy_avatar
    if params[:id]
      if @user.avatar
        @user.remove_avatar = true
        @user.save
        image_path = File.join(Rails.root,
                               'dynamic_files',
                               Rails.env,
                               'user',
                               'avatar',
                               params[:id])
        FileUtils.rmdir(image_path)
      end
    end
    redirect_to(@user)
  end

  private

  def pw_present(old_params)
    if old_params[:password].blank? && old_params[:password_confirmation].blank?
      old_params.delete(:password)
      old_params.delete(:password_confirmation)
    end
    old_params
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    if !current_user.nil? && current_user.is_admin?
      params.require(:user).permit(:id,
                                   :avatar,
                                   :first_name,
                                   :last_name,
                                   :password,
                                   :password_confirmation,
                                   :email,
                                   :role_id)
    else
      params.require(:user).permit(:id,
                                   :avatar,
                                   :first_name,
                                   :last_name,
                                   :password,
                                   :password_confirmation,
                                   :email)
    end
  end
end
