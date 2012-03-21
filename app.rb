require 'sinatra'
require_relative 'forerunner'

enable :sessions

base_path = Dir.home
default_projects = %w{cas wld-api-router wld-service-site portal portal-sites wld-service-communication wld-service-member wld-service-search mobile}

get '/' do
  session[:runner] = Forerunner.new(Dir.home + '/Projects/')
  @projects = default_projects
  erb :index
end

post '/start' do
  list = params.each_key.collect { |x| x }
  session[:runner].boot list
end
