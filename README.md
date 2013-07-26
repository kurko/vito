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

Vito currently works only in development.

## Documentation

[Read the documentation](http://github.com/kurko/vito/blob/master/docs/manual.md)

## Contributing

Integration tests are run with Vagrant, you have to install it first. **Important**:
don't use the gem, but the newer packaged installation. In fact, you should
uninstall it (removing binstubs even) or Bundler will start complaining.

Once you clone the repo, run:

```bash
$ rake setup:download_vagrant_box
```

This will download a VirtualBox image, initialize it with Vagrant and take a
initial snapshot. Whenever you run a spec, we'll roll back to this snapshot
to test it in a clean slate.

Add recipes to the `recipes/` dir. You can base your recipe on the existing ones.

Also, take a look at the rake tasks for running specs, e.g `rake spec:unit`,
`rake spec:acceptance`, `rake spec:all` etc

Once you're ready to push:

1. Fork the repo
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Run specs with `rake spec:all` (check `rake -T` for more options)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
