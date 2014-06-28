require "hashie"
require "json"

module Hubspotter
  class Response
    attr_accessor :data
    attr_reader   :code, :raw

    def initialize(http_response)
      @raw  = http_response
      @code = http_response.code
      @data = JSON.parse http_response.body.force_encoding("UTF-8")
    end

    def success?
      !!code.match(/^20\d$/)
    end

    def error
      h = Hashie::Mash.new(data)
      begin
        h.message = message_string_to_json(h.message)
        "#{h.message.msg}; #{h.message.error}"
      rescue
      end

    end


    private

    # For some very dumb reason, Hubspot sends the value of the "message" key
    # back as an escaped JSON object, so we have to jump through hoops to
    # parse it into a nice Hashie rather than a double-escaped string.
    def message_string_to_json(message)
      unescaped = message.tr('\\\\"', '"')
      Hashie::Mash.new JSON.parse unescaped
    end
  end
end
