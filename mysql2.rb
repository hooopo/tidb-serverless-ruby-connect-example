# Import the MySQL2 library
require 'mysql2'
require 'uri'

# Get TiDB Serverless credentials from environment variables

if ENV['DATABASE_URL']
  uri = URI.parse(ENV['DATABASE_URL'])
  ENV['TIDB_HOST'] = uri.host
  ENV['TIDB_PORT'] = uri.port.to_s
  ENV['TIDB_USERNAME'] = uri.user
  ENV['TIDB_PASSWORD'] = uri.password
  ENV['TIDB_DATABASE'] = uri.path[1..-1]
end

HOST = ENV['TIDB_HOST']
PORT = ENV['TIDB_PORT']
USERNAME = ENV['TIDB_USERNAME']
PASSWORD = ENV['TIDB_PASSWORD']
DATABASE = ENV['TIDB_DATABASE'] || 'information_schema'

puts "Connecting to the TiDB Serverless instance..."
client = Mysql2::Client.new(
  host: HOST,
  port: PORT,
  username: USERNAME,
  password: PASSWORD,
  database: DATABASE,
  sslverify: true
)
puts "Connected successfully."

resp = client.query('select version()')
puts resp.first

# Close the client connection
puts "Closing the client connection..."
client.close
puts "Connection closed."