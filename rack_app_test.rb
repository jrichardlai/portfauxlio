require "rubygems"
require "rack"
require "mail"
require "mocha"
require "minitest/autorun"
require File.expand_path("../lib/initializer", __FILE__)
require File.expand_path("../lib/rack_app", __FILE__)

Mail.defaults do
  delivery_method :test
end

describe RackApp do
  include Mail::Matchers

  after do
    Mocha::Mockery.instance.teardown
    Mocha::Mockery.reset_instance
  end
  
  before do
    @request = Rack::MockRequest.new(RackApp)
  end

  it "returns a 404 response for unknown requests" do
    @request.get("/unknown").status.must_equal 404
  end

  it "/ displays the page" do
    @request.get("/").body.must_include "Email"
  end

  describe "#email" do
    it "send email to the user" do
      response = @request.post("/mail", params: { name: "John Doe" , email: "johndoe@example.com", message: "message" })
      response.status.must_equal 202
      email = Mail::TestMailer.deliveries.last
      email.subject.must_equal "Message from John Doe (johndoe@example.com)"
    end

    it "require that all params are sent" do
      RackApp.expects(:mail).never
      response = @request.post("/mail")
      response.status.must_equal 400
    end

    it "returns 400 if the email cannot be send" do
      RackApp.stubs(:mail).returns(false)
      response = @request.post("/mail", params: { name: "John Doe" , email: "johndoe@example.com", message: "message" })
      response.status.must_equal 400
    end
  end
end