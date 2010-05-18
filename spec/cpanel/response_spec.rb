require 'spec_helper'

describe Cpanel::Response do
  describe ".new" do
    before(:each) do
      @http_response = stub('http response')
    end

    it "should parse the provided http response" do
      Cpanel::Response.any_instance.expects(:parse_response).with(@http_response)
      Cpanel::Response.new(@http_response)
    end

    it "should assign the parsed response to data" do
      parsed_response = stub
      Cpanel::Response.any_instance.stubs(:parse_response).returns(parsed_response)
      response = Cpanel::Response.new(@http_response)
      response.data.should eql(parsed_response)
    end
  end

  describe "#errors" do
    before(:each) do
      Cpanel::Response.any_instance.stubs(:parse_response).returns({})
      @response = Cpanel::Response.new("")
    end
    
    it "should return nil if success?" do
      @response.stubs(:success?).returns(true)
      result = @response.errors
      result.should be_nil
    end

    context "when success? is false" do
      before(:each) do
        @response.stubs(:success?).returns(false)
      end

      context "when statusmsg is set" do
        before(:each) do
          @statusmsg_stub = stub
          @response.stubs(:statusmsg).returns(@statusmsg_stub)
        end

        it "should return the statusmsg" do
          @response.errors.should eql(@statusmsg_stub)
        end
      end
      
      context "when statusmsg is not set" do
        before(:each) do
          @response.stubs(:statusmsg).returns(nil)
        end

        it "should return nil" do
          @response.errors.should be_nil
        end
      end
    end
  end

  describe "#success?" do
    before(:each) do
      Cpanel::Response.any_instance.stubs(:parse_response).returns({})
      @response = Cpanel::Response.new("")
    end

    context "when status is set" do
      before(:each) do
        @response.stubs(:status).returns(1)
      end

      it "should compare status to 1" do
        status_stub = stub
        status_stub.expects(:==).with(1)
        @response.stubs(:status).returns(status_stub)
        @response.success?
      end

      it "should return the result of the compare" do
        status_stub = stub(:== => "COMPARE RESULT")
        @response.stubs(:status).returns(status_stub)
        @response.success?.should == "COMPARE RESULT"
      end
    end
    
    context "when status is not set" do
      before(:each) do
        @response.stubs(:status).returns(nil)
      end

      it "should return true" do
        @response.success?.should be_true
      end
    end
  end

  describe "#[]" do
    before(:each) do
      @data = stub
      Cpanel::Response.any_instance.stubs(:parse_response).returns(@data)
      @response = Cpanel::Response.new("")
    end

    it "should call [] with the given key on the data" do
      @data.expects(:[]).with('key')
      @response['key']
    end

    it "should return the value from data" do
      @data.stubs(:[]).returns('value')
      @response['key'].should == 'value'
    end
  end

  describe "#parse_response" do
    it "should raise an exception" do
      # This is called within initialize so to catch the exception, we need to call new
      lambda { Cpanel::Response.new("") }.should raise_error()
    end
  end

  describe "#method_missing" do
    before(:each) do
      @data = stub
      Cpanel::Response.any_instance.stubs(:parse_response).returns(@data)
      @response = Cpanel::Response.new("")
    end

    it "should return the value from data if data has the correct key" do
      @data.expects(:has_key?).with('key').returns(true)
      @data.expects(:[]).with('key').returns('value')
      @response.key.should == 'value'
    end
  end
end
