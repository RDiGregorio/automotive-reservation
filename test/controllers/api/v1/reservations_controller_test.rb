require "test_helper"

class Api::V1::ReservationsControllerTest < ActionDispatch::IntegrationTest
  def json_response
    ActiveSupport::JSON.decode @response.body
  end

end
