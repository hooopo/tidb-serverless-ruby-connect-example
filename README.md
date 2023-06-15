# TiDB Serverless Ruby Connect Example

In this example, we will demonstrate how to connect to a TiDB Serverless instance using Ruby and [mysql2](https://github.com/brianmario/mysql2) gem and rails.

### mysql2 

First, please make sure you have Ruby and the mysql2 gem installed.

```bash
$ ruby -v
$ bundle install
```

Then, you can run the example code to connect to a TiDB Serverless instance using mysql2 gem.

```bash
$ TIDB_HOST=<tidb-serverless-host> TIDB_PORT=<tidb-serverless-port> TIDB_USERNAME=<tidb-serverless-username> TIDB_PASSWORD=<tidb-serverless-password> ruby mysql2.rb  
```

The code in `mysql2.rb` is as follows:

```ruby
require 'mysql2'

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
  ssl_mode: :verify_identity
)

puts "Connected successfully."

resp = client.query('select version()')
puts resp.first

# Close the client connection
puts "Closing the client connection..."
client.close
puts "Connection closed."
```

When it connects successfully, you will see the following output:

```bash
Connecting to the TiDB Serverless instance...
Connected successfully.
{"version()"=>"5.7.25-TiDB-v6.6.0-serverless"}
Closing the client connection...
Connection closed.
```

It's essential to note that the best practice for establishing SSL connections using the mysql2 gem is to set `ssl_mode` to `verify_identity` and set `sslca` to `nil`. By default, the mysql2 gem will search for existing CA certificates in a particular order until a file is discovered.

1. /etc/ssl/certs/ca-certificates.crt # Debian / Ubuntu / Gentoo / Arch / Slackware
2. /etc/pki/tls/certs/ca-bundle.crt # RedHat / Fedora / CentOS / Mageia / Vercel / Netlify
3. /etc/ssl/ca-bundle.pem # OpenSUSE
4. /etc/ssl/cert.pem # MacOS / Alpine (docker container)

While it is possible to specify the CA certificate path manually, this approach may cause significant inconvenience in multi-environment deployment scenarios, as different machines and environments may store the CA certificate in varying locations. Therefore, setting `sslca` to `nil` is recommended for flexibility and ease of deployment across different environments.

```ruby
client = Mysql2::Client.new(
  host: HOST,
  port: PORT,
  username: USERNAME,
  password: PASSWORD,
  database: DATABASE,
  ssl_mode: :verify_identity,
  sslca: '/path/to/ca-certificates.crt'
)
```

### Rails

If you are using Rails, you can configure the database connection in `config/database.yml` as follows:

```yaml
# Install the MySQL driver
#   gem install mysql2
#
# Ensure the MySQL gem is defined in your Gemfile
#   gem "mysql2"

default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  url: <%= ENV['DATABASE_URL'] %>
  ssl_mode: :verify_identity

development:
  <<: *default
  database: your_database_name
```

Make sure `ssl_mode` is set to `verify_identity` to enable SSL connections. Also, it is best practice to set `sslca` to `nil` or ignore it in the `config/database.yml` file. 

More information about the ca certificate path to connect to TiDB Serverless can be found [here](https://docs.pingcap.com/tidbcloud/secure-connections-to-serverless-tier-clusters)

```yaml

## Need help?

If you have any questions about TiDB Serverless, please join the [TiDB community](https://ask.pingcap.com/) and feel free to ask for help.
