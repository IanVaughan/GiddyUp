class Project
  attr_accessor :name, :pid, :port

  def initialize name
    @name = name
    @pid = 0
  end

  def running?
    pid > 0
  end

end
