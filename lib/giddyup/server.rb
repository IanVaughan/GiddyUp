require 'sinatra/base'

module GiddyUp
  class Server < Sinatra::Base

    configure do
      set :public_folder, Proc.new { File.join(root, "static") }
      # enable :sessions
    end

    get '/' do
      GiddyUp.logger.debug '/'
      @projects = GiddyUp.launcher.projects
      erb :index
    end

    get '/list/:path' do
      GiddyUp.logger.debug '/list'
      puts " #{params[:path]}"
    end

    post '/perform' do
      GiddyUp.logger.debug "/perform -> #{params}"
      GiddyUp.launcher.action params
    end

  end
end
