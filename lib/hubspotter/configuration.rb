module Hubspotter
  class Configuration
    attr_accessor :api_key, :http_open_timeout, :http_read_timeout

    def initialize
      @api_key           = 'demo'
      @http_open_timeout = 20
      @http_read_timeout = 45
    end
  end
end
