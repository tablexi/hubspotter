module Hubspotter
  class Error              < StandardError; end
  class AuthorizationError < Error; end
  class ConnectionError    < Error; end
  class InvalidPath        < Error; end
  class InvalidMethod      < Error; end
end
