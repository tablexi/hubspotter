require "json"

module Hubspotter
  class Response
    attr_accessor :data

    def initialize(http_response)
      @data = JSON.parse http_response.body.force_encoding("UTF-8")
    end
  end
end
