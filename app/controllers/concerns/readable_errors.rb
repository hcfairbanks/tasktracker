module ReadableErrors
  extend ActiveSupport::Concern

  def formated_errors(obj)
    message = ''
    if !obj.errors.full_messages.blank?
      obj.errors.full_messages.each do |error_message|
        message += error_message + '. '
      end
    else
      message = obj.class.name.titlecase + t(:not_destroyed)
    end
    message
  end
end
