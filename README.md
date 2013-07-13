# Vito

Vito installs webservers for you very easily. Its goal is to be opinionated,
with a shallow learning curve needed due to the use of a Gemfile-like specification
file.

```ruby
server :linode do
  connection :ssh, :command => "vagrant ssh -c" }

  install :rbenv
  install :git
  install :ruby, version: "2.0.0-p195"
  install :tmux
  install :apache do
    vhosts_for :rails, port: 80
    vhosts_for :rails, port: 443
  end
  install :passenger, with: :apache
end

server :ec2 do
  install :postgres do
    allow_connection from: :linode
  end

  # ...
end
```

Along with the installation process, it'll also be able to output status reports
about a particular server.

For now, it won't be hosted, just sending SSH messages instead.

## Working packages

These are the packages that are currently working:

rbenv, git, ruby, postgres

## Usage

Vito is not read for production yet.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
