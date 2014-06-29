require "hubspotter/request"

class RequestFoundry
  def self.default
    Hubspotter::Request.new(
      '/path',
      :get,
      url_params: { key: 'value' },
      post_body: 'body')
  end

  def self.get_contacts
    Hubspotter::Request.new("/contacts/v1/lists/all/contacts/all", :get)
  end

  def self.update_contact
    Hubspotter::Request.new(
      "/contacts/v1/contact/vid/231258/profile",
      :post,
      post_body: '{"properties":[]}')
  end
end
