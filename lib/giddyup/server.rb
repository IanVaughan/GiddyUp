require 'sinatra/base'

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

  end
end
