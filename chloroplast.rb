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

get '/css/style.css' do
  sass :style
end

helpers do
  def title ; 'Chloroplast' end
  def page_classes ; 'page' end
  def jquery_version ; '1.8.2' end
  def jquery_cdn_url
    "//ajax.googleapis.com/ajax/libs/jquery/#{jquery_version}/jquery.min.js"
  end
  def jquery_local_url ; "js/libs/jquery-#{jquery_version}.min.js" end
  def modernizr_url ; 'js/libs/modernizr.custom.21789.js' end
end

