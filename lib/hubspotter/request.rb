require "net/http"
require "uri"
require "hubspotter/exception"
require "hubspotter/response"

module Hubspotter
  class Request
    attr_accessor :method, :path, :post_body, :url_params
    attr_reader   :response

    HOST = "https://api.hubapi.com"

    def initialize(path, method, url_params: {}, post_body: nil)
      self.method = method
      @path       = path
      @url_params = url_params
      @post_body  = post_body
    end

    def send
      http_response = get? ? request_get : request_post
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

    def raise_errors(http_response)
      case http_response.code
      when "401"
        raise AuthorizationError
      when "404"
        raise InvalidPath
      when "405"
        raise InvalidMethod
      when /^50\d$/
        raise ConnectionError
      end
    end

    def request_get
      request = Net::HTTP::Get.new(uri(url_params_with_hapikey))
      http.request(request)
    end

    def request_post
      request = Net::HTTP::Post.new(uri(url_params_with_hapikey))
      http.request(request, post_body)
    end

    def url_params_with_hapikey
      url_params.merge({ hapikey: Hubspotter.configuration.api_key })
    end

    def uri(param_hash = nil)
      uri = URI.parse(HOST + path)
      uri.query = URI.encode_www_form(param_hash) if param_hash
      uri
    end
  end
end
