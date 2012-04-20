require 'giddyup/term_me'

module GiddyUp
  class Launcher
    attr_accessor :projects

    def initialize base_path = '.'
      @pid ||= {}
      @base_path = base_path
      @projects = `ls #{base_path}`.split
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
      GiddyUp.logger.debug "killing #{pid}"
      # pid && Process.kill(signal, pid)
      Process.kill(:INT, pid)
    rescue Errno::ESRCH => e
      GiddyUp.logger.error e
      false
    end

    def port
      `cat .foreman | awk '{ print $2 }'`
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
        # TermMe.open path, project # make optional
        # open http://0.0.0.0:$port

        GiddyUp.logger.debug "port : " + `cat .foreman`

        check_app_can_log

        # pid = Process.spawn('. ~/.profile; rbenv shell `cat .rbenv-version`; foreman start > log/foreman.log 2>&1')
        # pid = Process.spawn('. ~/.profile && rbenv shell `cat .rbenv-version` && foreman start > log/foreman.log 2>&1')
        pid = fork do
          # ENV.update
          # exec '. ~/.profile && rbenv shell `cat .rbenv-version` && foreman start > log/foreman.log 2>&1'
          exec GiddyUp.runner, "foreman start" # > log/foreman.log"
        end

        GiddyUp.logger.debug "pid:#{pid}, pgrp:#{Process.getpgrp}"

        Process.detach(pid)
      end

      pid
    end

  end
end
