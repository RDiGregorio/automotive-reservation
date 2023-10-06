class Api::V1::VehiclesController < ApplicationController
  before_action :find_vehicle, only: [:show, :update, :destroy]

  # GET /vehicles
  def index
    @vehicles = Vehicle.all
    render json: @vehicles
  end

  # GET /vehicles/:id
  def show
    @vehicle = Vehicle.find(params[:id])
    render json: @vehicle
  end

  # POST /vehicles/:id
  def create
    @vehicle = Vehicle.new(vehicle_params)
    if @vehicle.save
      render json: @vehicle
    else
      render json: { error: 'Failed to create vehicle.' }, status: 400
    end
  end

  # PUT /vehicles/:id
  def update
    @vehicle = Vehicle.find(params[:id])
    if @vehicle
      @vehicle.update(vehicle_params)
      render json: { message: 'Vehicle updated.' }, status: 200
    else
      render json: { error: 'Failed to update vehicle.' }, status: 400
    end
  end

  # POST /vehicles
  def destroy
    @vehicle = Vehicle.find(params[:id])
    if @vehicle
      @vehicle.destroy
      render json: { message: 'Vehicle deleted.' }, status: 200
    else
      render json: { error: 'Failed to delete vehicle.' }, status: 400
    end
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(:customer_id, :make, :model, :color, :registration_number)
  end

  def find_vehicle
    @vehicle = Vehicle.find(params[:id])
  end
end
