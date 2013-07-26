server :ruby_server, :one do
  # Vagrant box
  connection :ssh, command: "ssh -i ~/.vagrant.d/insecure_private_key vagrant@localhost -p2222"

  install :rbenv
  install :git
  install :ruby, version: "1.9.3-p125"
  install :postgres
  #install :tmux
  #install :ruby_gem, :bundler
  #install :passenger
end