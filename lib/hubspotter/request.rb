require "net/http"
require "uri"
require "hubspotter/exception"
require "hubspotter/response"

module Hubspotter
  class Request
    attr_accessor :parameters, :path, :method
    attr_reader   :response

    HOST = "https://api.hubapi.com"

    def initialize(path, method, params = {})
      @path       = path
      self.method = method
      @parameters = params
    end

    def send
      request = get? ? get_request : post_request
      http_response = http.request(request)
      raise_errors(http_response)
      @response = Response.new(http_response)
    end

    def method=(request_method)
      raise InvalidMethod \
        unless %w|get post|.any?{ |m| m == request_method.to_s.downcase }
      @method = request_method
    end


    private

    def http
      net_http = Net::HTTP.new(uri.host, 443)
      net_http.open_timeout = Hubspotter.configuration.http_open_timeout
      net_http.read_timeout = Hubspotter.configuration.http_read_timeout
      net_http.use_ssl = true

      # verify cert using system cert store
      net_http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      net_http
    end

    def get?
      method.to_s.downcase == "get"
    end

    def get_request
      Net::HTTP::Get.new(uri(paramaters_with_api_key))
    end

    def paramaters_with_api_key
      parameters.merge({ hapikey: Hubspotter.configuration.api_key })
    end

    def post_request
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(paramaters_with_api_key)
      request
    end

    def raise_errors(http_response)
      case http_response.code
      when "200"
      when "202"
      when "401"
        raise AuthorizationError
      when "404"
        raise InvalidPath
      else
        raise ConnectionError
      end
    end

    def uri(param_hash = nil)
      uri = URI.parse(HOST + path)
      uri.query = URI.encode_www_form(param_hash) if param_hash
      uri
    end
  end
end
