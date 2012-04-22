require 'giddyup/term_me'

module GiddyUp
  class Launcher
    attr_accessor :projects, :open_terminal, :open_browser

    def initialize base_path = '.'
      @pid ||= {}
      @base_path = base_path
      @projects = `ls #{base_path}`.split
      @open_terminal = true
      @open_browser = true
    end

    def start projects
      GiddyUp.logger.debug "#{__method__} -> #{projects}"
      return unless valid projects
      projects = [projects] unless projects.is_a? Array
      projects.each { |p| start! p }
    end

    def stop projects
      GiddyUp.logger.debug "#{__method__} -> #{projects}"
      return unless valid projects
      projects = [projects] unless projects.is_a? Array
      projects.each { |p| stop! p }
    end

    def list
      @pid.each_pair do |key, pid|
        puts "list : #{key} => #{pid}"
      end
    end

  private

    def valid args
      return if args.nil?
      return if args.is_a? Array and args.empty?
      return if args.is_a? Hash #and args.empty?
      true
    end

    def start! project
      @pid[project] = launch project unless @pid.has_key? project
      GiddyUp.logger.debug @pid[project]
    end

    def stop! project
      GiddyUp.logger.debug "stop : #{project}"
      GiddyUp.logger.debug list
      unless @pid.empty?
        kill @pid[project]
        @pid.delete(@pid[project])
      end
    end

    def kill pid
      GiddyUp.logger.debug "kill -> #{pid}"
      # pid && Process.kill(signal, pid)
      Process.kill(:INT, pid)
    rescue Errno::ESRCH => e
      GiddyUp.logger.error e
      false
    end

    def port
      `cat .foreman | awk '{ print $2 }'`.chomp
    end

    def check_app_can_log
      Dir.mkdir 'log' unless File.directory? 'log'
      # touch log/development.log
    end

    def launch project
      GiddyUp.logger.debug "#{__method__} -> #{project}"

      path = File.join(@base_path, project)
      GiddyUp.logger.debug "#{__method__} -> #{path}"

      pid = 0
      Dir.chdir path do
        GiddyUp.logger.debug "port : " + `cat .foreman`
        check_app_can_log

        open_web_page port, 'status' if open_browser
        TermMe.open path, project if open_terminal

        # pid = Process.spawn('. ~/.profile; rbenv shell `cat .rbenv-version`; foreman start > log/foreman.log 2>&1')
        # pid = Process.spawn('. ~/.profile && rbenv shell `cat .rbenv-version` && foreman start > log/foreman.log 2>&1')
        pid = fork do
          # ENV.update etc
          # exec '. ~/.profile && rbenv shell `cat .rbenv-version` && foreman start > log/foreman.log 2>&1'
          exec GiddyUp.runner, "foreman start" # > log/foreman.log"
        end

        GiddyUp.logger.info "Launched #{project} with pid:#{pid}, pgrp:#{Process.getpgrp}"
        Process.detach(pid)
      end

      pid
    end

    def open_web_page port, path = ''
      GiddyUp.logger.debug "#{__method__} -> #{port}"
      pid = fork do
        sleep 3
        exec "open http://0.0.0.0:#{port}/#{path}"
      end
      Process.detach pid
    end

  end
end
