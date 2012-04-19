require 'giddyup/term_me'

module GiddyUp
  class Launcher
    attr_accessor :projects

    def initialize base_path = '.'
      @pid ||= {}
      @projects = `ls #{base_path}`.split
    end

    def start args
      return unless valid args
      return start_many args if args.is_a? Array
      start_a args
    end

    def stop args
      return unless valid args
    end

private

    def valid args
      return if args.nil?
      return if args.is_a? Array and args.empty?
      return if args.is_a? Hash #and args.empty?
      true
    end

    def start_a project
      @pid[project] = launch project
      # log pid
    end

    def stop_a project
      puts "stop : #{project}"
      list
      unless @pid.empty?
        puts "killing #{@pid[project]}"
        Process.kill(:INT, @pid[project])
        @pid.delete(@pid[project])
      end
    end

    def start_many projects
      projects.each { |p| start_a p }
    end

    def stop_many projects
      projects.each { |p| stop p }
    end

    def list
      @pid.each_pair do |key, pid|
        puts "list : #{key} => #{pid}"
      end
    end

    private

    def launch project
      path = @base_path + project
      current_dir = Dir.pwd
      Dir.chdir path

      # TermMe.open path, project # make optional
      # port = `cat .foreman | awk '{ print $2 }'`
      # open http://0.0.0.0:$port

      # puts "--| #{project} - " + `cat .foreman`

      Dir.mkdir 'log' unless File.directory? 'log'
      # touch log/development.log

      # pid = Process.spawn('. ~/.profile; rbenv shell `cat .rbenv-version`; foreman start > log/foreman.log 2>&1')
      # puts "spawn:#{pid}"
      # puts Process.getpgrp
      #Process.detach(pid)

      Dir.chdir current_dir
      pid
    end

  end
end
