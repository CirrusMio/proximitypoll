require_relative '../lib/authentication.rb'
class InProximity < Sinatra::Base
  include Authentication

  configure do
    enable :logging
    file = File.new(File.expand_path('log/proximitypoll.log'), 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end

  before '/poll/*' do
    if authenticate(params[:token])
    else
      halt 403, haml('Access Denied')
    end
  end

  poll = lambda do
    `poll #{params[:words]}` if params
	^^^Need to verify parameters
  end

  get '/poll', &poll
  post '/poll', &poll
end
