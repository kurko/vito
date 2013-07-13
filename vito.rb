server :ruby_server, :one do
  connection :ssh, { :command => "vagrant ssh -c" }

  #install :rbenv
  #install :git
  #install :ruby, version: "1.9.3-p125"
  install :postgres
  #install :tmux
  #install :ruby_gem, :bundler
  #install :passenger
end
