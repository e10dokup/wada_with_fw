#!/usr/bin/env ruby
# coding:utf-8

require 'sinatra'
require 'rack'
require 'json'
require 'time'
require 'active_record'
Dir[File.expand_path('../passby', __FILE__) << '/*.rb'].each do |file|
  require file
end
ActiveRecord::Base.default_timezone = :local # config.active_record.default_timezone

get '/' do
  erb :main
end

get '/user/' do
  erb :user_reg
end

get '/passby/' do
  erb :passby_reg
end

get '/api/passby/' do
  data = {data: "hoge"}
  data.to_json
end

post '/api/passby', provides: :json do
  params = JSON.parse request.body.read
  passby = Passby.new(nil, params["datetime"], params["object_1"], params["object_2"], 1, nil, nil, nil, nil)
  passby.insert
  data = {result: 'success'}
  status 201
  data.to_json
end

post '/api/passby/create_multi/', provides: :json do
  params = JSON.parse request.body.read
  params.each do |param|
    datetime = DateTime.parse(param["datetime"]).strftime("%Y-%m-%dT%H:%M:%S")
    passby = Passby.new(nil, datetime, param["object_1"], param["object_2"], 1, nil, nil, nil, nil)
    passby.insert
  end
  data = {result: 'success'}
  status 201
  data.to_json
end

get '/api/passby/all/' do
  Passby::get_all
end

get '/api/passby/search/' do
  date = params[:datetime]
  begin_time = Date.parse(date).beginning_of_day.strftime("%Y-%m-%dT%H:%M:%S")
  end_time = Date.parse(date).end_of_day.strftime("%Y-%m-%dT%H:%M:%S")
  Passby.search(params[:object_1], params[:object_2], params[:app_id], params[:distance], params[:location], params[:accuracy], params[:type], params[:user_id], begin_time, end_time, params[:times]).to_json
end

post '/api/user/create/' do
  params = JSON.parse request.body.read
  user = User.new(params["id"], params["uid"], params["type"])
  user.create
end