class AttachmentsController < ApplicationController
  include ReadableErrors
  load_and_authorize_resource
  before_action :set_attachment, only: [:destroy]

  def serve_thumb
    send_file(@attachment.doc.thumb_path,
              disposition: 'inline',
              x_sendfile: true,
              type: 'image/jpeg',
              filename: "thumb_" + @attachment.original_name)
  end

  def serve_doc
    send_file(@attachment.doc.doc_path,
              disposition: 'inline',
              x_sendfile: true,
              filename: @attachment.original_name)
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def create
    @attachment = Attachment.new(attachment_params)
    respond_to do |format|
      if @attachment.save
        # @task.send_slack
        format.html { redirect_to @attachment, notice: t('attachment.created') }
        format.json { render json: @attachment, status: :created }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    task = Task.find(@attachment.task_id)
    respond_to do |format|
      if @attachment.destroy
        format.html { redirect_to(task) }
        format.json { render json: {text: "success"} }
      else
        format.html { redirect_to(task, alert: formated_errors(@attachment)) }
        format.json { render json: task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_priorities
    task = Attachment.find(attachment_params[:priorities_list]["0"][:id]).task
    errors = ""
    attachment_params[:priorities_list].each do |key, value|
      attachment = Attachment.find(value[:id])
      attachment.priority = value[:priority]
      unless attachment.save
        errors += attachment.errors no_worries
      end
    end

    respond_to do |format|
      if errors.blank?
        format.html { redirect_to(task) }
        format.json { render json: {text: "success"} }
      else
        errors = t('success') + errors
        format.html { redirect_to(task, alert: errors) }
        format.json { render json: { errors: errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:doc,:priority,:original_name,:task_id, priorities_list: [:id,:priority])
  end

end
