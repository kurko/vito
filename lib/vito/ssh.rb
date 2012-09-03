require 'rubygems'
require 'net/ssh'

module Vito
  class Ssh
    def initialize(host, username)
      @host = host
      @username = username
      @connection = Net::SSH.start(@host, @username)
      puts "Opened SSH connection."
    end

    def close
      @connection.close
      puts "Closed SSH connection."
    end

    def run(command)
      puts "\t['#{command}']"
      stdout_data = ""
      stderr_data = ""
      exit_code = nil
      exit_signal = nil
      ssh = @connection
      ssh.open_channel do |channel|
        channel.exec(command) do |ch, success|
          unless success
            abort "FAILED: couldn't execute command (ssh.channel.exec)"
          end

          channel.on_data do |ch,data|
            stdout_data+=data
          end

          channel.on_extended_data do |ch,type,data|
            stderr_data+=data
          end

          channel.on_request("exit-status") do |ch,data|
            exit_code = data.read_long
          end

          channel.on_request("exit-signal") do |ch, data|
            exit_signal = data.read_long
          end
        end
      end
      ssh.loop
      
      result = [stdout_data, stderr_data, exit_code, exit_signal]
      if exit_code === 0
        puts "\t[success]"
      else
        puts "\t[failure]"
        puts "RESULT"
        puts result.inspect
      end

      result
    end
  end
end
