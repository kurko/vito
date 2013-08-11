# Vito

Vito installs webservers for you very easily. Its goal is to be opinionated,
with a shallow learning curve needed due to the use of a Gemfile-like specification
file.

[![Build Status](https://travis-ci.org/kurko/vito.png?branch=master)](https://travis-ci.org/kurko/vito)

```ruby
server :linode do
  connection :ssh, :command => "ssh deploy@your_server_com"

  install :rbenv
  install :git
  install :ruby, version: "2.0.0-p195"
  install :apache do
    # install vhosts for port 80 and 443
    vhosts with: :ssl, path: "/var/projects"
    with :passenger
  end

  install :tmux
end

server :ec2 do
  # ...

  install :postgres, username: 'vito', password: 'corleone'
end
```

Along with the installation process, it'll also be able to output status reports
about a particular server.

For now, it won't be hosted, just sending SSH messages instead.

## Usage

Vito is unstable and we do not advise using this on production yet. Let us do
more tests first.

## Working packages

These are the packages that are currently working:

* Rbenv
* Git
* Ruby
* PostgreSQL
* Apache (including Passenger)

## Documentation

[Read the documentation](http://github.com/kurko/vito/blob/master/docs/manual.md)

## Contributing

Integration tests are run with Vagrant, so please install it first. **Important**:
don't use the gem, but the newer packaged installation. In fact, you should
uninstall it (removing binstubs even) or Bundler will start complaining.

#### Vagrant test boxes

We have acceptance test for different operating systems (e.g Ubuntu, CentOS etc).
Once you clone the repo, run:

```bash
$ bundle exec rake setup:download_vagrant_box
```

This will download VirtualBox images in `spec/vagrant_boxes/` automatically if
they're not present, initialize them with Vagrant and take a initial snapshot.
Whenever you run a spec, we'll roll back to this snapshot
to test it in a clean slate.

Each box has around 400Mb in size, so make sure you have enough space. For a list
of to-be-downloaded boxes, see the `Rakefile`.

Add recipes to the `recipes/` dir. You can just clone the existing ones.

Also, take a look at the rake tasks for running specs, e.g `rake spec:unit`,
`rake spec:acceptance`, `rake spec:all` etc

Once you're ready to push:

1. Fork the repo
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Run specs with `rake spec:all` (check `rake -T` for more options)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
