class StatusesController < ApplicationController
  include ReadableErrors
  load_and_authorize_resource
  before_action :set_status, only: [:show, :edit, :update, :destroy]

  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.all
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
  end

  # GET /statuses/new
  def new
    @status = Status.new
  end

  # GET /statuses/1/edit
  def edit
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = Status.new(status_params)

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: t('status.created') }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to @status, notice: t('status.updated') }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    respond_to do |format|
      if @status.destroy
        format.html { redirect_to statuses_url, notice: t('status.destroyed') }
        format.json { head :no_content }
      else
        format.html { redirect_to(statuses_url, alert: formated_errors(@status) ) }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:name, :description)
  end
end
