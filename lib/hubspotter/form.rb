require "hashie"
require "json"
require "uri"
require "hubspotter/request"

module Hubspotter
  class Form
    BASE_PATH = "/forms/v1"

    # Submit an existing form.  The portal_id must be set in the Hubspotter
    #   configuration.
    #
    # @param form_guid [Integer] form_guid supplied by HubSpot once the form is
    #   created.
    # @option form_data [Hash] :form_data ({}) a single level hash of keys
    #   and values
    # @option context_data [Hash] :context_data ({}) a single level hash; keys
    #   should correspond to the hsContext keys outlined in the HubSpot API
    #   documentation
    #
    # @return [Boolean] indicates if the request is successful
    #
    # @raise [InvalidPath] if the portal_id or form_guid is incorrect
    # @raise [AuthorizationError] if your api_key is incorrect or portal_id
    #   is missing
    # @raise [ConnectionError] if there is a problem connecting to the API
    def self.submit(form_guid, form_data: {}, context_data: {} )
      raise AuthorizationError, "Invalid portal_id" unless portal_id
      host    = "https://forms.hubspot.com"
      path    = "/uploads/form/v2/#{portal_id}/#{form_guid}"
      request = Hubspotter::Request.new(
        path,
        :post,
        post_body: post_body(form_data, context_data),
        host:      host)
      request.send.success?
    end


    private

    # @note HubSpot has a weird format for form submissions.  It expects a URI
    #   query string as the post body, though the contents of the "hs_context"
    #   field is JSON.
    def self.post_body(form_data, context_data)
      context_json = hs_context_json(context_data)
      query_string_hash = form_data.merge({ hs_context: context_json })
      hash_to_query_string(query_string_hash)
    end

    def self.hs_context_json(context_data)
      context_data.select{ |k,v| hs_context_fields.include?(k.to_s) }.to_json
    end

    def self.hash_to_query_string(hash)
      URI.encode_www_form(hash)
    end

    def self.hs_context_fields
      %w|hutk ipAddress pageUrl pageName redirectUrl sfdcCampaignId|
    end

    def self.portal_id
      Hubspotter.configuration.portal_id
    end
  end
end
