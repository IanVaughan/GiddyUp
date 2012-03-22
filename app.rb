require 'sinatra'
require_relative 'lib/forerunner'

enable :sessions

base_path = Dir.home
default_projects = %w{cas wld-api-router wld-service-site portal portal-sites wld-service-communication wld-service-member wld-service-search mobile}

get '/' do
  session[:runner] = Forerunner.new(Dir.home + '/Projects/')
  @projects = default_projects
  erb :index
end

post '/perform' do
  start_list = params.each_pair.collect { |key, value| key if value == 'start' }.compact
  stop_list = params.each_pair.collect { |key, value| key if value == 'stop' }.compact
  session[:runner].boot_up start_list if !start_list.empty?
  session[:runner].tear_down stop_list if !stop_list.empty?
end
