require 'spec_helper'

describe Cpanel::Manage2 do
  describe ".new" do
    it "should store the username" do
      @client = Cpanel::Manage2.new('username', 'password')
      @client.username.should == 'username'
    end

    it "should store the password" do
      @client = Cpanel::Manage2.new('username', 'password')
      @client.password.should == 'password'
    end
  end
  
  describe "#add_license" do
    before(:each) do
      @client = Cpanel::Manage2.new('username', 'password')

      @client.stubs(:groups).returns({ 'group_id' => {}})
      @client.stubs(:packages).returns({ 'package_id' => {}})

      @response = stub("Response Object")
      Cpanel::Response::Yaml.stubs(:new).returns(@response)

      @get_response = stub("Get Response")
      @client.stubs(:get).returns(@get_response)
    end
    
    it "should make a get request to '/XMLlicenseAdd.cgi'" do
      @client.expects(:get).with(regexp_matches(/^\/XMLlicenseAdd.cgi.*$/))
      @client.add_license('127.0.0.1')
    end
    
    it "should set legal to 1" do
      @client.expects(:get).with(regexp_matches(/legal=1/))
      @client.add_license('127.0.0.1')      
    end
    
    it "should set force to 0" do
      @client.expects(:get).with(regexp_matches(/force=0/))
      @client.add_license('127.0.0.1')      
    end
    
    it "should set the ip address" do
      @client.expects(:get).with(regexp_matches(/ip=127\.0\.0\.1/))
      @client.add_license('127.0.0.1')      
    end
    
    it "should set the group id" do
      @client.expects(:get).with(regexp_matches(/groupid=group_id/))
      @client.add_license('127.0.0.1')      
    end
    
    it "should set the package id to that provided" do
      @client.expects(:get).with(regexp_matches(/groupid=new_group_id/))
      @client.add_license('127.0.0.1', {:groupid => 'new_group_id'})
    end

    it "should set the package id to that provided" do
      @client.expects(:get).with(regexp_matches(/groupid=new_group_id/))
      @client.add_license('127.0.0.1', {'groupid' => 'new_group_id'})
    end
    
    it "should set the package id" do
      @client.expects(:get).with(regexp_matches(/packageid=package_id/))
      @client.add_license('127.0.0.1')      
    end
    
    it "should set the package id to that provided" do
      @client.expects(:get).with(regexp_matches(/packageid=new_package_id/))
      @client.add_license('127.0.0.1', {:packageid => 'new_package_id'})
    end

    it "should set the package id to that provided" do
      @client.expects(:get).with(regexp_matches(/packageid=new_package_id/))
      @client.add_license('127.0.0.1', {'packageid' => 'new_package_id'})
    end

    it "should create a Yaml response object" do
      Cpanel::Response::Yaml.expects(:new).with(@get_response).returns(@response)
      @client.licenses
    end

    it "should return the reponse object" do
      @client.licenses.should eql(@response)
    end
  end

  describe "#licenses" do
    before(:each) do
      @client = Cpanel::Manage2.new('username', 'password')

      @response = stub("Response Object")
      Cpanel::Response::Yaml.stubs(:new).returns(@response)

      @get_response = stub("Get Response")
      @client.stubs(:get).returns(@get_response)
    end

    it "should make a get request to '/XMLlicenseInfo.cgi?output=yaml'" do
      @client.expects(:get).with('/XMLlicenseInfo.cgi?output=yaml').returns(@get_response)
      @client.licenses
    end

    it "should create a Yaml response object" do
      Cpanel::Response::Yaml.expects(:new).with(@get_response).returns(@response)
      @client.licenses
    end

    it "should return the reponse object" do
      @client.licenses.should eql(@response)
    end
  end

  describe "#expire_license" do
    before(:each) do
      @client = Cpanel::Manage2.new('username', 'password')

      @response = stub("Response Object")
      Cpanel::Response::Yaml.stubs(:new).returns(@response)

      @get_response = stub("Get Response")
      @client.stubs(:get).returns(@get_response)
    end

    it "should make a get request to '/XMLlicenseExpire.cgi'" do
      @client.expects(:get).with(regexp_matches(/XMLlicenseExpire.cgi/)).returns(@get_response)
      @client.expire_license('id')
    end

    it "should pass the license id in the get request" do
      @client.expects(:get).with(regexp_matches(/liscid=id/)).returns(@get_response)
      @client.expire_license('id')      
    end

    it "should pass the default expire code of 'normal'" do
      @client.expects(:get).with(regexp_matches(/expcode=normal/)).returns(@get_response)
      @client.expire_license('id')      
    end

    it "should pass the provided expire code of 'normal'" do
      @client.expects(:get).with(regexp_matches(/expcode=exp_code/)).returns(@get_response)
      @client.expire_license('id', 'exp_code')      
    end

    it "should create a Yaml response object" do
      Cpanel::Response::Yaml.expects(:new).with(@get_response).returns(@response)
      @client.expire_license('id')
    end

    it "should return the reponse object" do
      @client.expire_license('id').should eql(@response)
    end
  end

  describe "#groups" do
    before(:each) do
      @client = Cpanel::Manage2.new('username', 'password')

      @response = stub("Response Object")
      Cpanel::Response::Yaml.stubs(:new).returns(@response)

      @get_response = stub("Get Response")
      @client.stubs(:get).returns(@get_response)
    end

    it "should make a get request to '/XMLgroupInfo.cgi?output=yaml'" do
      @client.expects(:get).with('/XMLgroupInfo.cgi?output=yaml').returns(@get_response)
      @client.groups
    end

    it "should create a Yaml response object" do
      Cpanel::Response::Yaml.expects(:new).with(@get_response).returns(@response)
      @client.groups
    end

    it "should return the reponse object" do
      @client.groups.should eql(@response)
    end
  end

  describe "#packages" do
    before(:each) do
      @client = Cpanel::Manage2.new('username', 'password')

      @response = stub("Response Object")
      Cpanel::Response::Yaml.stubs(:new).returns(@response)

      @get_response = stub("Get Response")
      @client.stubs(:get).returns(@get_response)
    end

    it "should make a get request to '/XMLpackageInfo.cgi?output=yaml'" do
      @client.expects(:get).with('/XMLpackageInfo.cgi?output=yaml').returns(@get_response)
      @client.packages
    end

    it "should create a Yaml response object" do
      Cpanel::Response::Yaml.expects(:new).with(@get_response).returns(@response)
      @client.packages
    end

    it "should return the reponse object" do
      @client.packages.should eql(@response)
    end
  end

  describe "#get (private method)" do
    before(:each) do
      @client = Cpanel::Manage2.new('username', 'password')
    end

    it "should get to the given url with the given data" do
      stub_request(:any, 'https://username:password@manage2.cpanel.net/test_api.cgi')
      @client.send(:get, "/test_api.cgi")
      WebMock.should have_requested(:get, "https://username:password@manage2.cpanel.net/test_api.cgi")
    end
  end

  describe "#post (private method)" do
    before(:each) do
      @client = Cpanel::Manage2.new('username', 'password')
    end

    it "should post to the given url with the given data" do
      stub_request(:any, 'https://username:password@manage2.cpanel.net/test_api.cgi')
      @client.send(:post, "/test_api.cgi", {'key' => 'value'})
      WebMock.should have_requested(:post, "https://username:password@manage2.cpanel.net/test_api.cgi").with( :headers => {'key' => 'value'} )
    end
  end

end
