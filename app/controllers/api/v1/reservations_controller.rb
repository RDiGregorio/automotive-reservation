class Api::V1::ReservationsController < ApplicationController
  # GET /reservations
  def index
    reservations = Reservation.where(vehicle_id: params[:vehicle_id])
    render json: reservations
  end

  # GET /reservations/:id
  def show
    reservation = Reservation.find_by(id: params[:id])
    if reservation
      render json: reservation
    else
      render json: { error: 'Failed to find reservation.' }, status: 400
    end
  end

  # POST /reservations
  def create
    reservation = Reservation.new(reservation_params)

    if open_reservations.any? { |open_reservation| reservation.conflicts_with open_reservation }
      render json: { error: 'Failed to create reservation because of a scheduling conflict.' }, status: 400
      return
    end

    if reservation.save
      render json: reservation
    else
      render json: { error: 'Failed to create reservation.' }, status: 400
    end
  end

  # PUT /reservations/:id
  def update
    reservation = Reservation.find_by(id: params[:id])
    reservation.assign_attributes(reservation_params)

    if open_reservations.any? { |open_reservation| (open_reservation.id != reservation.id) && reservation.conflicts_with(open_reservation) }
      render json: { error: 'Failed to update reservation because of a scheduling conflict.' }, status: 400
      return
    end

    if reservation.save
      render json: { message: 'Reservation updated.' }, status: 200
    else
      render json: { error: 'Failed to update reservation.' }, status: 400
    end
  end

  # DELETE /reservations
  def destroy
    reservation = Reservation.find_by(id: params[:id])
    if reservation
      reservation.destroy
      render json: { message: 'Reservation deleted.' }, status: 200
    else
      render json: { error: 'Failed to delete reservation.' }, status: 400
    end
  end

  private

  def reservation_params
    params.permit(:vehicle_id, :date, :time, :description, :status, :duration_hours)
  end

  def open_reservations
    Reservation.where.not(status: 'Closed').to_a
  end
end
