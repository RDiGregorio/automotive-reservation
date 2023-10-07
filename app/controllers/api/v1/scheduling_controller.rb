class Api::V1::SchedulingController < ApplicationController
  # POST /scheduling
  def create
    # todo: should i worry about time collisions? endpoint security?

    customer = Customer.find_by(license_number: params[:license_number]) || Customer.new(customer_params)

    unless customer.save
      render json: { error: 'Failed to create or update customer.' }, status: 400
      return
    end

    vehicle = Vehicle.find_by(registration_number: params[:registration_number]) || Vehicle.new(vehicle_params(customer.id))

    unless vehicle.save
      render json: { error: 'Failed to create or update vehicle.' }, status: 400
      return
    end

    reservation = Reservation.new(reservation_params(vehicle.id))

    unless reservation.save
      render json: { error: 'Failed to create reservation.' }, status: 400
      return
    end

    render json: reservation
  end

  private

  def customer_params
    params.permit(:first_name, :last_name, :license_number, :phone_number, :email)
  end

  def vehicle_params(customer_id)
    params[:customer_id] = customer_id
    params.permit(:customer_id, :make, :model, :color, :registration_number)
  end

  def reservation_params(vehicle_id)
    params[:vehicle_id] = vehicle_id
    params.permit(:vehicle_id, :date, :time, :description, :status)
  end
end
