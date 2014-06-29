require "hashie"
require "hashie"
require "json"
require "hubspotter/request"

module Hubspotter
  class Contact
    BASE_PATH = "/contacts/v1"

    # List all contacts.  Returns up to 20 at a time.
    #
    # @todo support contact pagination
    #
    # @return [Array] each element is a Hashie of contact details built from
    #   the JSON from Hubspot
    #
    # @raise [HubspotError] if the API returns an error
    # @raise [AuthorizationError] if your api_key is incorrect
    # @raise [ConnectionError] if there is a problem connecting to the API
    def self.all
      path = BASE_PATH + "/lists/all/contacts/all"
      request = Hubspotter::Request.new(path, :get)
      response = request.send
      raise_errors(response)
      deserialize_contacts(response.data)
    end

    # Create a new contact.
    #
    # @param properties [Hash] dictionary of key/value properties you wish to
    #   associate with the contact
    #
    # @return [Integer] vid of the newly created contact
    #
    # @raise [HubspotError] if the API returns an error
    # @raise [AuthorizationError] if your api_key is incorrect
    # @raise [ConnectionError] if there is a problem connecting to the API
    def self.create(properties = {})
      path = BASE_PATH + "/contact"
      get_vid(create_or_update(path, properties))
    end

    # Update an existing contact.
    #
    # @param vid [Integer] id of the
    # @param properties [Hash] dictionary of key/value properties you wish to
    #   associate with the contact
    #
    # @return [Integer] vid of the newly created contact
    #
    # @raise [HubspotError] if the API returns an error
    # @raise [AuthorizationError] if your api_key is incorrect
    # @raise [ConnectionError] if there is a problem connecting to the API
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
      response.data ? Hashie::Mash.new(response.data) : true
    end

    def self.deserialize_contacts(hashed_contacts)
      contacts = []
      hashed_contacts["contacts"].each do |hashed_contact|
        contacts << Hashie::Mash.new(hashed_contact)
      end
      contacts
    end

    def self.get_vid(response_hash)
      response_hash['canonical-vid']
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
