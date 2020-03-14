class TasksController < ApplicationController
  include ReadableErrors
  load_and_authorize_resource
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
    @tasks = @tasks.filter_like(params.slice(:title, :description))
    @tasks = @tasks.filter_exact(params.slice(:id,
                                              :reported_by,
                                              :assigned_to,
                                              :priority,
                                              :status,
                                              :vertical,
                                              :request_type))
    @tasks = params[:order_by].blank? ? @tasks.order(id: :desc) :
                                        @tasks.order(params[:order_by])
    @tasks = @tasks.paginate(page: params[:page], per_page: 8)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    flash.now[:notice] = params[:notice] if !params[:notice].blank?
    @comments = Comment.where(task: @task).order(id: :desc)
    @comment = Comment.new
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        # @task.send_slack
        format.html { redirect_to @task, notice: t("task.created") }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: t("task.updated") }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @task.destroy
        format.html { redirect_to tasks_url, notice: t("task.destroyed") }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { redirect_to tasks_url, formated_errors(@task) }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title,
                                 :description,
                                 :reported_by_id,
                                 :assigned_to_id,
                                 :status_id,
                                 :request_type_id,
                                 :member_facing,
                                 :vertical_id,
                                 :title,
                                 :link,
                                 :required_by,
                                 :priority_id,
                                 attachments_attributes: [:doc,
                                                          :original_name,
                                                          :priority])
  end
end
