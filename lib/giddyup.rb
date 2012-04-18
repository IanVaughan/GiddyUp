require_relative 'term_me'

class GiddyUp

  def initialize base_path = '.'
    @pid ||= {}
    @base_path = base_path
  end

  def launch project
    path = @base_path + project
    current_dir = Dir.pwd
    Dir.chdir path

    TermMe.open path, project # make optional
    # port = `cat .foreman | awk '{ print $2 }'`
    # open http://0.0.0.0:$port

    puts "--| #{project} - " + `cat .foreman`

    Dir.mkdir 'log' if !File.directory?('log')
    # touch log/development.log

    pid = Process.spawn('. ~/.profile; rbenv shell `cat .rbenv-version`; foreman start > log/foreman.log 2>&1')
    puts "spawn:#{pid}"
    puts Process.getpgrp
    #Process.detach(pid)

    Dir.chdir current_dir
    pid
  end

  def start project
    @pid[project] = launch project
  end

  def stop project
    puts "stop : #{project}"
    list
    unless @pid.empty?
      puts "killing #{@pid[project]}"
      Process.kill(:INT, @pid[project])
      @pid.delete(@pid[project])
    end
  end

  def boot_up projects
    projects.each { |p| start p }
    puts @pid.inspect
  end

  def tear_down projects
    projects.each { |p| stop p }
  end

  def list
    @pid.each_pair do |key, pid|
      puts "list : #{key} => #{pid}"
    end
  end
end
