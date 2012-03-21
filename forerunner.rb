require 'open3'

# List branches for each project in drop down

class Forerunner

  attr_accessor :threads

  def initialize
    @threads = {}
  end

  def projects base_path = '.'
    `ls #{base_path}`.split(' ')
  end

  def self.test
    count = 0
    threads = {}
    2.times do |i|
      threads[i] = Thread.new do
        sleep(rand(0.1))
        Thread.current[:mycount] = count
        count += 1
      end
    end
    threads.class
    threads.each { |t|
      t.join
      #puts t.inspect
      #t.each { |tt| puts tt.inspect }
      print t[1][:mycount], ", "
    }
    puts "count = #{count}"
  end

  def launch project
    `cd #{base_path}/#{project}`
    print "--| #{project} - on" `cat .foreman`
    `mkdir -p log`
    ver = `cat .rbenv-version`
    `rbenv shell #{ver}`
    `nohup foreman start > log/foreman.log 2>&1 &`
  end

  def start base_path, project
    puts "#project : #{project}"
    @threads[project] = Thread.new(project) do |p|
      puts "=== start #{p} ==="
      #stdin, stdout, stderr = Open3.popen3("cd #{p}; foreman start")
      #Thread.current[:stdin] = stdin
      #Thread.current[:stdout] = stdout
      #Thread.current[:stderr] = stderr
      Thread.current[:io] = IO.popen(". ~/.profile; cd #{base_path+project}; rbenv shell `cat .rbenv-version`; foreman start")
      #sleep 3
      puts '--- started'
    end
    puts '--- start:end'
  end

  def boot selection
    selection.each { |p| start p }
  end

  def list
    #@threads.each(&:join)
    @threads.each_pair do |key, thread|
      puts "list : #{key}"
      #puts thread[:stdout]
      #puts thread[:stderr]
      #puts thread.inspect
      puts thread[:io].readlines unless thread[:io].nil?
    end
  end

end
