require_relative 'term_me'

class Forerunner

  def initialize base_path = '.'
    @threads = {}
    @base_path = base_path
  end

  def launch project
    path = @base_path + project
    Dir.chdir path

    TermMe.open path project # make optional
    # port = `cat .foreman | awk '{ print $2 }'`
    # open http://0.0.0.0:$port

    puts "--| #{project} - " + `cat .foreman`

    Dir.mkdir 'log' if !File.directory?('log')
    # touch log/development.log

    exec '. ~/.profile; rbenv shell `cat .rbenv-version`; foreman start > log/foreman.log 2>&1'

    # never gets here!
  end

  def start project
    @threads[project] = Thread.new(project) do |p|
      Thread.current[:pid] = fork do
        launch project
      end
    end
  end

  def stop project
    puts @threads[project][:pid] if !@threads.empty?
  end

  def boot_up projects
    projects.each { |p| start p }
  end

  def tear_down projects
    projects.each { |p| stop p }
  end

  def list
    @threads.each_pair do |key, thread|
      puts "list : #{key}"
      puts thread[:pid] unless thread[:pid].nil?
    end
  end
end
