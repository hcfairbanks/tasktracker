class Role < ApplicationRecord
  ADMIN      = 'admin'
  BUSINESS   = 'business'
  UNASSIGNED = 'unassigned'
  DEACTIVATED = 'deactivated'

  has_many :users, dependent: :restrict_with_error
  validates :name, uniqueness: true, presence: true

end
