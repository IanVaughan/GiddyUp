a = `ruby demo.rb > test &`
p a


pid = spawn("echo hello")
STDOUT.flush
rc, status = Process::waitpid2(pid)
puts "Status = #{status}"



reader, writer = IO.pipe
pid = spawn("echo '4*a(1)' | bc -l", [ STDERR, STDOUT ] => writer) writer.close
Process::waitpid2(pid)
reader.gets # => "3.14159265358979323844\n"

