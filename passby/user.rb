require 'net/http'
require 'uri'
require 'json'

class User

  def initialize(id, uid, type)
    @id = id
    @uid = uid
    @type = type
  end

  def create
    params = {}
    unless @id.nil?
      params = params.merge({idstr: @id})
    end
    unless @uid.nil?
      params = params.merge({uid: @uid})
    end
    unless @type.nil?
      params = params.merge({type: @type})
    end

    encoded_params = URI.encode_www_form(params)
    endpoint = URI.parse("http://192.168.0.9:50003/pbfw/api/pns/create?#{encoded_params}")
    req = Net::HTTP::Get.new(endpoint.request_uri)
    req['Accept'] = 'application/json'

    res = Net::HTTP.start(endpoint.host, endpoint.port) do |http|
      http.request(req)
    end

    res.body
  end

end