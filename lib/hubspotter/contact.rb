require "hashie"
require "hubspotter/request"


module Hubspotter
  class Contact < Hashie::Mash
    BASE_PATH = "/contacts/v1"

    def self.all
      path = BASE_PATH + "/lists/all/contacts/all"
      request = Hubspotter::Request.new(path, :get, {})
      response = request.send
      deserialize_contacts(response.data)
    end


    private

    def self.deserialize_contacts(hashed_contacts)
      contacts = []
      hashed_contacts["contacts"].each do |hashed_contact|
        contacts << Contact.new(hashed_contact)
      end
      contacts
    end
  end
end
