class Api::V1::CustomersController < ApplicationController
  # GET /customers
  def index
    if params[:first_name] and params[:last_name]
      @customers = Customer.where(first_name: params[:first_name], last_name: params[:last_name])
    else
      @customers = Customer.all
    end

    render json: @customers
  end

  # GET /customers/:id
  def show
    @customer = Customer.find(params[:id])
    render json: @customer
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      render json: @customer
    else
      render json: { error: 'Failed to create customer.' }, status: 400
    end
  end

  # PUT /customers/:id
  def update
    @customer = Customer.find(params[:id])
    if @customer
      @customer.update(customer_params)
      render json: { message: 'Customer updated.' }, status: 200
    else
      render json: { error: 'Failed to update customer.' }, status: 400
    end
  end

  # POST /customers
  def destroy
    @customer = Customer.find(params[:id])
    if @customer
      @customer.destroy
      render json: { message: 'Customer deleted.' }, status: 200
    else
      render json: { error: 'Failed to delete customer.' }, status: 400
    end
  end

  private

  def customer_params
    params.permit(:first_name, :last_name, :license_number, :phone_number, :email)
  end
end
