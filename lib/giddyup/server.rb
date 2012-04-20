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
      GiddyUp.logger.debug '/list'
      puts " #{params[:path]}"
    end

    get '/die' do
      GiddyUp.logger.debug '/die'
      redirect to('/')
    end

    post '/perform' do
      GiddyUp.logger.debug '/perform'

      GiddyUp.launcher.start params.each_pair.collect { |key, value| key if value == 'start' }.compact
      GiddyUp.launcher.stop params.each_pair.collect { |key, value| key if value == 'stop' }.compact
    end

  end
end
