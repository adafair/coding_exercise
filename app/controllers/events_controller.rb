class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :set_organization, only: [:index, :create]

  # GET /events
  def index
    @events = @organization.present? ? @organization.events : Event.all
    @events = @events.order("timestamp DESC")

    if params[:offset].present?
      @events = @events.offset(params[:offset])
    end

    if params[:limit].present?
      @events = @events.limit(params[:limit])
    end

    if params[:hostname].present?
      @events = @events.where(hostname: params[:hostname])
    end

    render json: @events
  end

  # GET /events/1
  def show
    render json: @event
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @organization
      @event.organization = @organization
    end

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
      if @event.nil?
        render json: {errors: ["not_found"]}, status: :not_found
      end
    end

    # Find organization by name if it is specified in the path as
    # :organization_id
    def set_organization
      @organization = nil
      if params[:organization_id].present?
        @organization = Organization.find_by_name(params[:organization_id])
        if @organization.nil?
          render json: {errors: ["not_found"]}, status: :not_found
        end
      end
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:message, :hostname, :timestamp)
    end
end
