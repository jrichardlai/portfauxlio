require 'yaml'

if File.exists?(File.join("config", "settings.yml"))
  $config = YAML.load_file(File.join("config", "settings.yml"))
else
  $config             = {}
  $config['email']    = ENV['EMAIL']
  $config['sent_to']  = ENV['SENT_TO']
  $config['password'] = ENV['PASSWORD']
end