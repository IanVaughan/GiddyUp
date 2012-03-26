require 'sinatra'
require_relative 'lib/forerunner'

enable :sessions

base_path = Dir.home

get '/' do
  project_path = Dir.home + '/Projects/'
  session[:runner] ||= Forerunner.new(project_path)
  @projects = `ls #{project_path}`.split
  @port = '3000'
  erb :index
end

get '/list/:path' do
  puts " #{params[:path]}"
end

get '/die' do
  session[:runner] = nil
  redirect to('/')
end

post '/perform' do
  start_list = params.each_pair.collect { |key, value| key if value == 'start' }.compact
  stop_list = params.each_pair.collect { |key, value| key if value == 'stop' }.compact
  session[:runner].boot_up start_list if !start_list.empty?
  session[:runner].tear_down stop_list if !stop_list.empty?
end
