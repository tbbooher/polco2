require 'spec_helper'

describe RepresentController do

  describe "GET 'house_bills'" do
    it "returns http success" do
      get 'house_bills'
      response.should be_success
    end
  end

  describe "GET 'senate_bills'" do
    it "returns http success" do
      get 'senate_bills'
      response.should be_success
    end
  end

end
