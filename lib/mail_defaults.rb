require 'mail'

Mail.defaults do
  delivery_method :smtp, {
    :address    => "smtp.gmail.com",
    :port       => 587,
    :user_name  => $config['email'],
    :password   => $config['password'],
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }
end