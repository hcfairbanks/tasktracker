class Task < ApplicationRecord
  after_create :default_assignment

  include Filterable
  MAX_ATTACHMENTS = 10
  belongs_to :request_type
  belongs_to :vertical
  belongs_to :priority
  belongs_to :status

  belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id'
  belongs_to :reported_by, class_name: 'User', foreign_key: 'reported_by_id'

  has_many :attachments, -> { order(priority: :asc) }, dependent: :destroy, inverse_of: :task
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :attachments

  validates :description, presence: true
  validates :reported_by, presence: true
  validates :required_by, presence: true

  def send_slack
    client = Slack::Web::Client.new
    client.auth_test
    message =  I18n.t("slack.vertical") + self.vertical.name + "\n"
    message += I18n.t("slack.id") + self.id.to_s + "\n"
    message += I18n.t("slack.description") + self.description + "\n"
    message += I18n.t("slack.request-type") + self.request_type.name + "\n"
    message += I18n.t("slack.member-facing") + self.member_facing.to_s + "\n"
    message += I18n.t("slack.link") + self.link + "\n"
    message += I18n.t("slack.priority") + self.priority.name + "\n"
    message += I18n.t("slack.title") + self.title + "\n"
    message += I18n.t("slack.requested-by") + User.find(self.reported_by).first_name + "\n"
    message += I18n.t("slack.timestamp") + self.created_at.strftime("%I:%M %p") + "\n"
    message += I18n.t("slack.reported-date") + self.created_at.strftime("%d/%b/%y") + "\n"
    message += I18n.t("slack.required-by") + self.required_by.strftime("%d/%b/%y") + "\n"
    client.chat_postMessage(channel: ENV['SLACK_CHANNEL'], text: message, as_user: true)
  end

  def default_assignment
    self.assigned_to ||= User.find_by_email(User::UNASSIGNED_USER)
    self.save
  end
end
