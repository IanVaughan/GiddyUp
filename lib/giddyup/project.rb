class Project
  attr_accessor :name, :pid, :port

  def initialize name, port
    @name, @port = name, port
    @pid = 0
  end

  def running?
    pid > 0
  end

end
