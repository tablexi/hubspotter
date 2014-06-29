require "hashie"
require "json"
require "hubspotter/request"


module Hubspotter
  class Contact < Hashie::Mash
    BASE_PATH = "/contacts/v1"

    def self.all
      path = BASE_PATH + "/lists/all/contacts/all"
      request = Hubspotter::Request.new(path, :get)
      response = request.send
      raise_errors(response)
      deserialize_contacts(response.data)
    end

    def self.create(properties = {})
      path = BASE_PATH + "/contact"
      create_or_update(path, properties)
    end

    def self.update(vid, properties = {} )
      path = BASE_PATH + "/contact/vid/#{vid}/profile"
      create_or_update(path, properties)
    end


    private

    def self.create_or_update(path, properties)
      body = properties_hash_to_json(properties)
      request = Hubspotter::Request.new(path, :post, post_body: body)
      response = request.send
      raise_errors(response)
      new(response.data)
    end

    def self.deserialize_contacts(hashed_contacts)
      contacts = []
      hashed_contacts["contacts"].each do |hashed_contact|
        contacts << Contact.new(hashed_contact)
      end
      contacts
    end

    def self.properties_hash_to_json(properties)
      hash = { properties: [] }
      properties.each do |key, value|
        hash[:properties] << { property: key.to_s, value: value }
      end
      hash.to_json
    end

    def self.raise_errors(response)
      return if response.success?
      case response.code
      when '409'
        raise HubspotError, response.error
      end
    end
  end
end
