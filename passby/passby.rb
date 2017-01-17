require 'net/http'
require 'uri'
require 'json'

class Passby

  def initialize(id, datetime, object_1, object_2, app_id, distance, location, accuracy, type)
    @id = id
    @datetime = datetime
    # @object_1 = object_1
    # @object_2 = object_2
    @app_id = app_id
    @distance = distance
    @location = location
    @accuracy = accuracy
    @type = type

    encoded_params = URI.encode_www_form({idstr: object_1, type: "BLE"})
    endpoint = URI.parse("http://192.168.0.9:50003/pbfw/api/pns/resolve?#{encoded_params}")
    req = Net::HTTP::Get.new(endpoint.request_uri)
    req['Accept'] = 'application/json'

    res = Net::HTTP.start(endpoint.host, endpoint.port) do |http|
      http.request(req)
    end

    @object_1 = res.body.to_i

    encoded_params = URI.encode_www_form({idstr: object_2, type: "BLE"})
    endpoint = URI.parse("http://192.168.0.9:50003/pbfw/api/pns/resolve?#{encoded_params}")
    req = Net::HTTP::Get.new(endpoint.request_uri)
    req['Accept'] = 'application/json'

    res = Net::HTTP.start(endpoint.host, endpoint.port) do |http|
      http.request(req)
    end

    @object_2 = res.body.to_i
  end

  def insert
    params = {}
    unless @datetime.nil?
      params = params.merge({datetime: @datetime})
    end
    unless @object_1.nil?
      params = params.merge({object1: @object_1})
    end
    unless @object_2.nil?
      params = params.merge({object2: @object_2})
    end
    unless @app_id.nil?
      params = params.merge({appId: @app_id})
    end
    unless @distance.nil?
      params = params.merge({distance: @distance})
    end
    unless @location.nil?
      params = params.merge({location: @location})
    end
    unless @accuracy.nil?
      params = params.merge({accuracy: @accuracy})
    end
    unless @type.nil?
      params = params.merge({type: @type})
    end
    encoded_params = URI.encode_www_form(params)
    endpoint = URI.parse("http://192.168.0.9:50003/pbfw/api/passby/insert?#{encoded_params}")
    req = Net::HTTP::Get.new(endpoint.request_uri)
    req['Accept'] = 'application/json'

    res = Net::HTTP.start(endpoint.host, endpoint.port) do |http|
      http.request(req)
    end

    res.body
  end

  def self.get_all
    endpoint = URI.parse("http://192.168.0.9:50003/pbfw/api/passby/getall")
    req = Net::HTTP::Get.new(endpoint.request_uri)
    req['Accept'] = 'application/json'

    res = Net::HTTP.start(endpoint.host, endpoint.port) do |http|
      http.request(req)
    end

    res.body
  end

  def self.search(object_1, object_2, app_id, distance, location, accuracy, type, user_id, begin_time, end_time, times)
    params = {}
    unless object_1.nil? || object_1 == ""
      params = params.merge({object1: object_1})
    end
    unless object_2.nil? || object_2 == ""
      params = params.merge({object2: object_2})
    end
    unless app_id.nil?
      params = params.merge({appId: app_id})
    end
    unless distance.nil?
      params = params.merge({distance: distance})
    end
    unless location.nil?
      params = params.merge({location: location})
    end
    unless accuracy.nil?
      params = params.merge({accuracy: accuracy})
    end
    unless type.nil?
      params = params.merge({type: type})
    end
    unless user_id.nil?
      params = params.merge({userid: user_id})
    end
    unless begin_time.nil?
      params = params.merge({begin: begin_time})
    end
    unless end_time.nil?
      params = params.merge({end: end_time})
    end
    encoded_params = URI.encode_www_form(params)
    endpoint = URI.parse("http://192.168.0.9:50003/pbfw/api/passby/search?#{encoded_params}")
    req = Net::HTTP::Get.new(endpoint.request_uri)
    req['Accept'] = 'application/json'

    p endpoint

    res = Net::HTTP.start(endpoint.host, endpoint.port) do |http|
      http.request(req)
    end

    if times == ""
      res.body
    else
      matched = []
      threshold = times.to_i
      ary = []
      response = JSON.parse res.body
      response['list'].each do |passby|
        object_2 = passby['object2']
        ary.push object_2
      end
      times_hash = ary.inject(Hash.new(0)){|hash, a| hash[a] += 1; hash}.select {|k,v| v >= threshold}
      p times_hash
      response['list'].each do |passby|
        if times_hash.key?(passby['object2'])
          matched.push(passby)
        end
      end
      result = {"list" => matched}
      result.to_json
    end
  end

end