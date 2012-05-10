class RackApp
  def self.call(env)
    new(env).response.finish
  end
  
  def initialize(env)
    @request = Rack::Request.new(env)
  end
  
  def response
    case @request.path
    when "/" then Rack::Response.new(File.open('public/index.html', File::RDONLY))
    when "/mail"
      return Rack::Response.new("Bad Request", 400) unless @request.params["email"] and @request.params["name"] and @request.params["message"]
      if self.class.mail(@request)
        Rack::Response.new("Accepted", 202)
      else
        Rack::Response.new("Bad Request", 400)
      end
    else
      Rack::Response.new("Not Found", 404)
    end
  end
  
  private 
  
  def self.mail(request)
    mail = Mail.new({
      from:    $config['email'],
      to:      $config['sent_to'],
      subject: "Message from #{request.params['name']} (#{request.params["email"]})",
      body:    "#{request.params['message']}"
    })
    mail.deliver!
  end
end