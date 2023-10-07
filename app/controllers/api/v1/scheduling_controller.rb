class Api::V1::SchedulingController < ApplicationController
  # GET /scheduling
  def index
    # Returns the reservations for a given customer.

    if params[:license_number]
      customers = Customer.where(license_number: params[:license_number])
    elsif params[:first_name] and params[:last_name]
      customers = Customer.where(first_name: params[:first_name], last_name: params[:last_name])

      if customers.empty?
        render json: { error: 'Failed to find customer.' }, status: 400
        return
      end

      # It's possible for 2 customers to have the same first and last name. Try to narrow it down to customers that have
      # an open reservation.

      customers = customers.to_a.select { |customer|
        customer.vehicles.any? { |vehicle|
          vehicle.reservations.any? { |reservation|
            reservation.status.upcase != "CLOSED"
          }
        }
      }

      if customers.size > 1
        render json: { error: 'Found multiple customers. Please search by license number.' }, status: 400
        return
      end
    else
      render json: { error: 'Failed to find customer.' }, status: 400
      return
    end

    reservations = customers.flat_map { |customer| customer.vehicles.flat_map { |vehicle| vehicle.reservations } }

    # We only want open reservations.

    render json: reservations.select { |reservation| reservation.status.upcase != "CLOSED" }
  end

  # POST /scheduling
  def create
    customer = Customer.find_by(license_number: params[:license_number]) || Customer.new(customer_params)

    unless customer.save
      render json: { error: 'Failed to find or create customer.' }, status: 400
      return
    end

    vehicle = Vehicle.find_by(registration_number: params[:registration_number]) || Vehicle.new(vehicle_params(customer.id))

    unless vehicle.save
      render json: { error: 'Failed to find or create vehicle.' }, status: 400
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
    params.permit(:vehicle_id, :date, :time, :description, :status, :duration_hours)
  end
end
