#!/usr/bin/env ruby
require 'sinatra'

if development?
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

set :haml, :format => :html5

get '/' do
  haml :index
end
