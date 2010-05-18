require 'spec_helper'

describe Cpanel::Response::Yaml do
  describe "#parse_response" do
    before(:each) do
      @http_response = stub(:body => 'http_body')
      @response = Cpanel::Response::Yaml.new(@http_response)
    end

    it "should load the http_response body using YAML" do
      YAML.expects(:load).with('http_body')
      @response.parse_response(@http_response)
    end

    it "should return the result of YAML::load" do
      YAML.stubs(:load).returns("RESULT")
      @response.parse_response(@http_response).should == "RESULT"
    end
  end
end
