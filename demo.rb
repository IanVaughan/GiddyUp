x=1
while true
  puts "hi #{x=x+1}"

  #system 'echo "t"' if x == 10
  STDOUT.flush

  sleep 1
end

# puts/print do not flush the stream
# echo does
# but I dont own the code/process writing to stdot, so I cant flush
# need to force it to flush?

IO.popen("s3sync.rb …").each do |line|
  print line
end

IO.popen cmd, 'r+' do |pipe|

   pipe.sync = true ### you can do this once

   loop do
     buf = pipe.gets

     case buf
       when /A/
         pipe.puts 'response_A'
       when /B/
         pipe.puts 'response_B'
     end

     pipe.flush ### or this after each write
   end

end
http://whynotwiki.com/Ruby_/_Process_management
http://en.wikibooks.org/wiki/Ruby_Programming/Running_Multiple_Processes
http://blog.jayfields.com/2006/06/ruby-kernel-system-exec-and-x.html
