# encoding: UTF-8

require "sinatra"
require "sinatra/json"
require "json"
require "securerandom"

set :bind, "0.0.0.0"
set :port, 3000
set :default_encoding, "utf-8"

settings.add_charset << "application/json" # it adds charset to content type

applications = []

Application = Struct.new(:id, :title, :status) do
  def submited?
    status == 'submited'
  end
end

get "/" do
  "Hello world!"
end

post "/applications" do
  id = SecureRandom.hex(10)
  applications << Application.new(id, "TITLE", "submited")
  status 201
  json id: id
end

post "/applications/:id/accept" do
  application = applications.find { |a| a.id == params[:id] } || :not_found


  if application == :not_found
    status 404
    return nil
  end

  unless application.submited?
    status 400
    return json type: "ALREADY_ACCEPTED"
  end

  application.status = "accepted"

  status 205
  nil
end


post "/applications/:id/reject" do
  application = applications.find { |a| a.id == params[:id] } || :not_found

  if application == :not_found
    status 404
    return nil
  end

  application.status = "rejected"

  status 205
  nil
end

get "/applications/:id" do
  application = applications.find { |a| a.id == params[:id] } || :not_found

  if application == :not_found
    status 404
    nil
  else
    json({
      title: application.title,
      status: application.status,
    })
  end
end
