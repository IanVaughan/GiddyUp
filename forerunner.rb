require_relative 'term_me'

class Forerunner

  #attr_accessor :threads

  def initialize base_path = '.'
    @threads = {}
    @base_path = base_path
  end

  def launch project
    Dir.chdir @base_path + project
    TermMe.go path

    puts "--| #{project} - " + `cat .foreman`
    Dir.mkdir 'log' if !File.directory?('log')
    ver = `cat .rbenv-version`
    #`. ~/.profile; rbenv shell #{ver}; foreman start > log/foreman.log 2>&1`
    exec '. ~/.profile; rbenv shell `cat .rbenv-version`; foreman start > log/foreman.log 2>&1'
    #`nohup foreman start > log/foreman.log 2>&1 &`
    #{}`foreman start > log/foreman.log 2>&1`
  end

  def start project
    @threads[project] = Thread.new(project) do |p|
      Thread.current[:pid] = fork do
        #Signal.trap('HUP', 'IGNORE') # Don't die upon logout
        launch project
      end
    end
  end

  def boot projects
    projects.each { |p| start p }
  end

  def list
    #@threads.each(&:join)
    @threads.each_pair do |key, thread|
      puts "list : #{key}"
      #puts thread[:stdout]
      #puts thread[:stderr]
      #puts thread.inspect
      puts thread[:pid] unless thread[:pid].nil?
    end
  end
end

#Process.detach(pid)
