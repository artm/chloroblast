#!/usr/bin/env ruby
require 'sinatra'
require 'coffee-script'
require 'json'
require_relative 'lib/scriptmanager'

if development?
  require 'rack-livereload'
  require 'sinatra/reloader'
  use Rack::LiveReload
end

set :haml, format: :html5
set :haml, locals: {
  title: 'Chloroplast',
  modernizr_url: 'js/libs/modernizr.custom.21789.js',
  jquery_cdn_url: '//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js',
  jquery_local_url: 'js/libs/jquery-1.8.2.min.js',
  paper_url: 'js/libs/paper.js',
  coffeescript_url: 'js/libs/coffee-script-1.3.3.min.js',
}

get '/' do
  haml :index
end

get '/css/style.css' do
  sass :style
end

get '/js/chloroplast.js' do
  coffee :chloroplast
end

sm = ScriptManager.new "scripts"

post '/api' do
  name = sm.save( params[:script] )
  JSON.dump( { name: name } )
end

get '/api/script_list' do
  JSON.dump( { script_list: sm.scripts.to_a } )
end

get '/scripts/:name' do
  fname = "scripts/#{params[:name]}.coffee"
  send_file fname
end
