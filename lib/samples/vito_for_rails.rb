server :rails_server do
  connection :ssh, user: "deploy", host: "0.0.0.0"

  install :rbenv
  install :git
  install :ruby, version: "1.9.3-p125"
  install :postgres
  install :tmux
  install :passenger do
    with :apache
    # will open port 80, plus 443
    vhosts_for :rails, with: :ssl, path: "/var/www/my_app/public"
  end
end
