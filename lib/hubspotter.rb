require "hashie"
require "json"
require "net/http"
require "uri"

require "hubspotter/configuration"
require "hubspotter/exception"
require "hubspotter/request"
require "hubspotter/response"
require "hubspotter/version"

module Hubspotter
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration = Configuration.new
  end
end
