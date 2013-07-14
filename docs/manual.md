_Atention: At this moment, this guide is our roadmap, not the actual manual._

## API guide

**Vito** uses a recipes file called `vito.rb` to determine what servers should
be installed. The `vito.rb` defines servers and theirs programs. An example:

```ruby
server :linode do
  # Vagrant box
  connection :ssh, command: "ssh -i ~/.vagrant.d/insecure_private_key vagrant@localhost -p2222"

  install :rbenv
  install :git
  install :ruby, version: "1.9.3-p125"
  install :postgres
  install :tmux
  install :ruby_gem, :bundler
  install :passenger
end
```

Here, we define the connection to the server and what should be installed in it.

## Getting started

Install Vito with

`$ gem install vito`

## Command-line

The following command will run Vito and try to load `vito.rb` file from the
current path.

`$ vito`

You can also define a particular file with

`$ vito my_file.rb`

Run `vito help` to see the available options you have.

## The `vito.rb` file

### connection(type, options)

Defines the connection to the server. The possible types are:

**ssh:** the server will be accessed via SSH. The possible options are:

* `command`: when you want to specify just a prefix, such as
`ssh deploy@12.34.56.78` or `vagrant ssh -c`. If you used the last, Vito would
send a command such as `vagrant ssh -c "rbenv install 1.9.3-p125"`. When
defining a command, you don't need to define other options (because the username
and host will already be included).
* `username`: if you define a username, you have to define a host.
* `host`
* `port`: defaults to 22
* `key`: path to file containing public key needed for the connection

**local:** when the server is the machine Vito is already running.

### install(program, options = {}, &block)

Defines what program should be installed. For a list of available programs, type

`$ vito programs`

Some programs accept blocks, such as `passenger` (allows you to use Rails with
Apache or nginx):

```ruby
install :passenger do
  with :apache
  # will open port 80, plus 443
  vhosts_for :rails, with: :ssl, path: "/var/www/my_app/public"
end
```
