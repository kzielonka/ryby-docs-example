require 'sinatra'
require 'json'
require 'securerandom'

set :bind, '0.0.0.0'
set :port, 3000

applications = []

Application = Struct.new(:id, :title, :status)

get '/' do
  'Hello world!'
end

post '/applications' do
  id = SecureRandom.hex(10)
  applications << Application.new(id, 'TITLE', 'submited')
  status 201
  content_type 'application/json'
  JSON.generate({ id: id })
end

post '/applications/:id/accept' do
  application = applications.find { |a| a.id == params[:id] } || :not_found

  if application == :not_found
    status 404
    return nil
  end

  application.status = 'accepted'

  status 205
  nil
end


post '/applications/:id/reject' do
  application = applications.find { |a| a.id == params[:id] } || :not_found

  if application == :not_found
    status 404
    return nil
  end

  application.status = 'rejected'

  status 205
  nil
end

get '/applications/:id' do
  application = applications.find { |a| a.id == params[:id] } || :not_found

  if application == :not_found
    status 404
    nil
  else
    content_type 'application/json'
    JSON.generate({
      title: application.title,
      status: application.status,
    })
  end
end
