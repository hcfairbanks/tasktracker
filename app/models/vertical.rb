class Vertical < ApplicationRecord
  has_many :tasks, dependent: :restrict_with_error
  validates :name, presence: true
end
