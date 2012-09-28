#!/usr/bin/env ruby
require 'sinatra'
if development?
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

get '/' do
  redirect to('/index.html')
end
