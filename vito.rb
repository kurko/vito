server :ruby_server, :one do
  # Vagrant box
  connection :ssh, command: "ssh -i ~/.vagrant.d/insecure_private_key vagrant@localhost -p2224"

  install :rbenv
  install :git
  install :ruby, version: "1.9.3-p125"
  #install :postgres, username: 'vito', password: 'corleone'
  install :apache do
    with :passenger
    vhosts with: :ssl, path: "/var/projects/someapp/current/public"
  end
  # install :tmux
end
