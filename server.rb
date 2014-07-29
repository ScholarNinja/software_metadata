require 'octokit'
require 'yaml'
require 'json'
require 'sinatra/base'
require 'faraday-http-cache'
require './software_metadata.rb'
require 'puma'
require 'pry'
@@software_metadata = SoftwareMetadata.new

class Server < Sinatra::Application
  set :software_metadata, @@software_metadata
  set :server, :puma
  get '/software_metadata' do
    content_type :json
    url = params[:url]

    if url =~ /^(https?:\/\/)?github.com\/(.+)\/(.+)$/
      owner = $2
      repo = $3
      response = settings.software_metadata.github(owner, repo)
    end

    if response && response.status == 200
      return response.body
    else
      halt(404)
    end
  end
end

Server.run!
