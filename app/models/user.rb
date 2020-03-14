class User < ApplicationRecord
  has_secure_password

  include Filterable
  UNASSIGNED_USER = 'unassigned@test.com'
  NO_AVATAR_THUMB = 'no_avatar_image_thumb.jpg'
  LOGIN_ATTEMPTS_MAX = 10

  belongs_to :role
  has_many :assignments, class_name: 'Task', foreign_key: 'assigned_to_id', dependent: :restrict_with_error
  has_many :reports,     class_name: 'Task', foreign_key: 'reported_by_id', dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error

  before_validation :assign_default_role
  after_destroy :remove_attachment_directory

  mount_uploader :avatar, AvatarUploader, dependent: :destroy
  validates_size_of :avatar, maximum: 5.megabyte, message: I18n.t('avatar.limit')
  validates :first_name, presence: { message: I18n.t('user.letters') }, format: { with: /[a-zA-z]/ }
  validates :last_name, presence: { message: I18n.t('user.letters') }, format: { with: /[a-zA-z]/ }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true
  validates :password, presence: true, length: { in: 6..20 }, if: :password_digest_changed?

  def is_admin?
    answer = false
    if !role.blank? && role.name == Role::ADMIN
      answer = true
    end
    answer
  end

  def is_business?
    answer = false
    if !role.blank? && role.name == Role::BUSINESS
      answer = true
    end
    answer
  end

  def assign_default_role
    self.role || self.role = Role.find_by_name('unassigned')
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  protected

  def remove_attachment_directory
    FileUtils.remove_dir(File.join(Rails.root,
                                   'dynamic_files',
                                   Rails.env,
                                   'user',
                                   'avatar',
                                   id.to_s), force: true)
  end
end
