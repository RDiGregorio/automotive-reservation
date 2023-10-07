class Api::V1::VehiclesController < ApplicationController
  # GET /vehicles
  def index
    vehicles = Vehicle.where(customer_id: params[:customer_id])
    render json: vehicles
  end

  # GET /vehicles/:id
  def show
    vehicle = Vehicle.find(params[:id])
    render json: vehicle
  end

  # POST /vehicles
  def create
    vehicle = Vehicle.new(vehicle_params)
    if vehicle.save
      render json: vehicle
    else
      render json: { error: 'Failed to create vehicle.' }, status: 400
    end
  end

  # PUT /vehicles/:id
  def update
    vehicle = Vehicle.find(params[:id])
    if vehicle
      vehicle.update(vehicle_params)
      render json: { message: 'Vehicle updated.' }, status: 200
    else
      render json: { error: 'Failed to update vehicle.' }, status: 400
    end
  end

  # DELETE /vehicles
  def destroy
    vehicle = Vehicle.find(params[:id])
    if vehicle
      vehicle.destroy
      render json: { message: 'Vehicle deleted.' }, status: 200
    else
      render json: { error: 'Failed to delete vehicle.' }, status: 400
    end
  end

  private

  def vehicle_params
    params.permit(:customer_id, :make, :model, :color, :registration_number)
  end
end
