#!/usr/bin/env ruby
require 'sinatra'

get '/' do
  redirect to('/index.html')
end
