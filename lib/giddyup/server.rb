require 'sinatra/base'
require 'json'

module GiddyUp
  class Server < Sinatra::Base

    configure do
      set :public_folder, Proc.new { File.join(root, "public") }
    end

    get '/' do
      GiddyUp.logger.debug '/'
      @projects = GiddyUp.launcher.projects
      @error = GiddyUp.launcher.error
      erb :index
    end

    post '/perform' do
      GiddyUp.logger.debug "/perform -> #{params}"
      GiddyUp.launcher.action params
    end

    get '/running.json/:project' do
      GiddyUp.logger.debug "/running -> #{params}, #{params[:project]}"
      running = GiddyUp.launcher.running? params[:project]
      content_type :json
      running.to_json
    end

    get '/running.json' do
      list = GiddyUp.launcher.list
      content_type :json
      list.to_json
    end
    end

  end
end
