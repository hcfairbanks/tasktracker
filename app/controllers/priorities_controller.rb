class PrioritiesController < ApplicationController
  include ReadableErrors
  load_and_authorize_resource
  before_action :set_priority, only: [:show, :edit, :update, :destroy]

  # GET /priorities
  # GET /priorities.json
  def index
    @priorities = Priority.all
  end

  # GET /priorities/1
  # GET /priorities/1.json
  def show
  end

  # GET /priorities/new
  def new
    @priority = Priority.new
  end

  # GET /priorities/1/edit
  def edit
  end

  # POST /priorities
  # POST /priorities.json
  def create
    @priority = Priority.new(priority_params)
    respond_to do |format|
      if @priority.save
        format.html { redirect_to @priority, notice: t('priority.created') }
        format.json { render :show, status: :created, location: @priority }
      else
        format.html { render :new }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /priorities/1
  # PATCH/PUT /priorities/1.json
  def update
    respond_to do |format|
      if @priority.update(priority_params)
        format.html { redirect_to @priority, notice: t('priority.updated') }
        format.json { render :show, status: :ok, location: @priority }
      else
        format.html { render :edit, notice: formated_errors(@priority) }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /priorities/1
  # DELETE /priorities/1.json
  def destroy
    respond_to do |format|
      if @priority.destroy
        format.html { redirect_to priorities_url, notice: t('priority.destroyed') }
        format.json { head :no_content }
      else
        format.html { redirect_to(priorities_url, alert: formated_errors(@priority)) }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_priority
    @priority = Priority.find(params[:id])
  end

  def priority_params
    params.require(:priority).permit(:name, :description)
  end
end
