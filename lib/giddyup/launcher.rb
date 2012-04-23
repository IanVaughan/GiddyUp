require 'giddyup/term_me'

module GiddyUp
  class Launcher
    attr_accessor :projects

    def initialize base_path = '.'
      @pid ||= {}
      @base_path = base_path
      @projects = dirs base_path
      @config = {term: true, browser: true}
    end

    # Takes a Hash, where
    # key -> name of project
    # value -> start or stop (or other which is ignored)
    def action projects
      GiddyUp.logger.debug "#{__method__} -> #{projects}"
      return unless valid projects
      projects.each do |project, action|
        GiddyUp.logger.debug "#{__method__} -> #{project}, #{action}"
        start! project if action == 'start'
        stop! project if action == 'stop'
      end
    end

    def list
      @pid.each_pair do |key, pid|
        puts "list : #{key} => #{pid}"
      end
    end

  private

    def dirs path
      # Dir.exist?("/tmp") # .keep_if(&:directory?) # all.delete_if { |f| Dir. }
      all = Dir.entries(path)
      all.keep_if { |d| Dir.exist? path + d }
      all.delete_if { |d| d == '.' or d == '..'}
    end

    def valid args
      return if args.nil?
      return unless args.is_a? Hash or !args.empty?
      true
    end

    def start! project
      GiddyUp.logger.debug "start! -> #{project}"
      @pid[project] = launch project unless @pid.has_key? project
    end

    def stop! project
      GiddyUp.logger.debug "stop! -> #{project}"
      GiddyUp.logger.debug list
      unless @pid.empty? # or !@pid.has_key? project
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
        GiddyUp.logger.debug "port : " + port
        check_app_can_log

        TermMe.open path, project if @config[:term]

        url = 'status' # Need to set differently depending on service?
        open_web_page port, url if @config[:browser]

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
