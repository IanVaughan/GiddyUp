require 'giddyup/term_me'
require 'giddyup/project'

module GiddyUp
  class Launcher
    attr_accessor :projects

    def initialize base_path = '.'
      @base_path = base_path
      @projects = {}

      project_names = dirs base_path
      project_names.each do |name|
        @projects[name] = Project.new name
      end

      @config = {term: true, browser: true}
    end

    # Takes a Hash, where
    # key -> name of project
    # value -> start or stop (or other which is ignored)
    # eg { 'project_a' => 'start', 'project_b' => 'stop' }
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
      @projects.each_pair do |project_name, config|
        puts "list : #{project_name} => #{config.pid}" if config.running?
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
      @projects[project].pid, @projects[project].port = launch project unless @projects[project].running?
      GiddyUp.logger.debug list
    end

    def stop! project
      GiddyUp.logger.debug "stop! -> #{project}"
      GiddyUp.logger.debug list
      kill @projects[project].pid if @projects[project].running?
      @projects[project].pid = 0
      GiddyUp.logger.debug list
    end

    def kill pid
      GiddyUp.logger.debug "kill -> #{pid}"
      pid && Process.kill(:INT, pid)
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

      pid_port = []
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

        pid_port << pid << port
        GiddyUp.logger.info "Launched #{project} has pid:#{pid} on port:#{port}, pgrp:#{Process.getpgrp}"
        Process.detach(pid)
      end

      pid_port
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
