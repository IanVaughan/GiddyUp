#!/usr/bin/ruby
require_relative 'forerunner'

projects=%w{cas wld-api-router wld-service-site portal portal-sites wld-service-communication wld-service-member wld-service-search mobile}

fr = Forerunner.new Dir.home + '/Projects/'
#fr.start 'wld-api-router'
fr.boot projects
fr.list

