require 'sinatra/base'

module GiddyUp
  class Server < Sinatra::Base

    configure do
      set :public_folder, Proc.new { File.join(root, "static") }
      # enable :sessions
    end

    helpers do
      def format names
        # "#{name}bar"
      end
    end

    base_path = Dir.home

    get '/' do
      GiddyUp.logger.debug '/'
      @projects = GiddyUp.launcher.projects
      @port = '3000'
      @running = false
      erb :index
    end

    get '/list/:path' do
      GiddyUp.logger.debug '/list'
      puts " #{params[:path]}"
    end

    post '/perform' do
      GiddyUp.logger.debug "/perform -> #{params}"

      GiddyUp.launcher.start params.each_pair.collect { |key, value| key if value == 'start' }.compact
      GiddyUp.launcher.stop params.each_pair.collect { |key, value| key if value == 'stop' }.compact
    end

  end
end
