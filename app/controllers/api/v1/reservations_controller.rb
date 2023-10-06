class Api::V1::ReservationsController < ApplicationController
  before_action :find_reservation, only: [:show, :update, :destroy]

  # GET /reservations
  def index
    #TODO: this probably shouldn't be a child of the vehicle
    @reservations = Reservation.all
    render json: @reservations
  end

  # GET /reservations/:id
  def show
    @reservation = Reservation.find(params[:id])
    render json: @reservation
  end

  # POST /reservations/:id
  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      render json: @reservation
    else
      render json: { error: 'Failed to create reservation.' }, status: 400
    end
  end

  # PUT /reservations/:id
  def update
    @reservation = Reservation.find(params[:id])
    if @reservation
      @reservation.update(reservation_params)
      render json: { message: 'Reservation updated.' }, status: 200
    else
      render json: { error: 'Failed to update reservation.' }, status: 400
    end
  end

  # POST /reservations
  def destroy
    @reservation = Reservation.find(params[:id])
    if @reservation
      @reservation.destroy
      render json: { message: 'Reservation deleted.' }, status: 200
    else
      render json: { error: 'Failed to delete reservation.' }, status: 400
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:vehicle_id, :date, :time, :description, :status)
  end

  def find_reservation
    @reservation = Reservation.find(params[:id])
  end
end
