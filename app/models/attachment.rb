class Attachment < ApplicationRecord
  after_destroy :remove_attachment_directory
  before_create :check_total_task_attachments

  mount_base64_uploader :doc, DocUploader, dependent: :destroy

  validates_presence_of :doc
  validates_presence_of :original_name
  validates_presence_of :priority

  validates_size_of :doc, maximum: 25.megabyte, message: I18n.t('attachment.limit')
  belongs_to :task, inverse_of: :attachments

  validates_associated :task, presence: true

  protected

  def check_total_task_attachments
    task = Task.find(self.task_id)
    if task.attachments.length >= Task::MAX_ATTACHMENTS
      throw(:abort)
    end
  end

  def remove_attachment_directory
    FileUtils.remove_dir(File.join(Rails.root,
                                   'dynamic_files',
                                   Rails.env,
                                   'attachment',
                                   'doc',
                                   id.to_s), force: true)
  end
end
