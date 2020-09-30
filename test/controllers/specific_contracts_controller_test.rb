require 'test_helper'

class SpecificContractsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get specific_contracts_update_url
    assert_response :success
  end

end
