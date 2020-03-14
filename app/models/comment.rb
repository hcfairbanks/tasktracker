class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task
  validates :content, presence: true
  validates :user, presence: true
  validates :task, presence: true
end
