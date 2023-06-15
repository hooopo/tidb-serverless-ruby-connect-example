# TiDB Serverless Ruby Connect Example

In this example, we will demonstrate how to connect to a TiDB Serverless instance using Ruby and [mysql2](https://github.com/brianmario/mysql2) gem.

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
  sslverify: true
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

It's essential to note that the best practice for establishing SSL connections using the mysql2 gem is to set `sslverify` to `true` and set `sslca` to `nil`. By default, the mysql2 gem will search for existing CA certificates in a particular order until a file is discovered.

* /etc/ssl/certs/ca-certificates.crt # Debian / Ubuntu / Gentoo / Arch / Slackware
* /etc/pki/tls/certs/ca-bundle.crt # RedHat / Fedora / CentOS / Mageia / Vercel / Netlify
* /etc/ssl/ca-bundle.pem # OpenSUSE
* /etc/ssl/cert.pem # Alpine (docker container)

While it is possible to specify the CA certificate path manually, this approach may cause significant inconvenience in multi-environment deployment scenarios, as different machines and environments may store the CA certificate in varying locations. Therefore, setting `sslca` to `nil` is recommended for flexibility and ease of deployment across different environments.

```ruby
client = Mysql2::Client.new(
  host: HOST,
  port: PORT,
  username: USERNAME,
  password: PASSWORD,
  database: DATABASE,
  sslverify: true,
  sslca: '/path/to/ca-certificates.crt'
)
```

## Need help?

If you have any questions about TiDB Serverless, please join the [TiDB community](https://ask.pingcap.com/) and feel free to ask for help.