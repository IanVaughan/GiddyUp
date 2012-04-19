require 'sinatra/base'

module GiddyUp
  class Server < Sinatra::Base

    helpers do
      def bar(name)
        "#{name}bar"
      end
    end

    base_path = Dir.home

    get '/' do
      GiddyUp.logger.debug '/'
      @projects = GiddyUp.launcher.projects
      @port = '3000'
      erb :index
    end

    get '/list/:path' do
      puts " #{params[:path]}"
    end

    get '/die' do
      redirect to('/')
    end

    post '/perform' do
      Launcher.start = params.each_pair.collect { |key, value| key if value == 'start' }.compact
      Launcher.stop = params.each_pair.collect { |key, value| key if value == 'stop' }.compact
    end

  end
end
