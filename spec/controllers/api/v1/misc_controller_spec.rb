require 'spec_helper'
require 'json'

describe Api::V1::MiscController do

  describe 'Connection' do

    it 'can test the connectablity through the test api' do
      expected = {
          :ret => 'OK'
      }.to_json
      get :test_connection, {}
      response.body.should == expected
    end
  end

end