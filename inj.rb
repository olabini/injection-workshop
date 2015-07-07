require 'sinatra'

get '/path' do
  file = params["file"]
  content_type :text
  File.read(file)
end

get '/command' do
  host = params["host"]
  content_type :text
  `host #{host}`
end
