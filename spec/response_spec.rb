require "spec_helper"
require "hubspotter/response"
require "hubspotter/request"

describe Hubspotter::Response do
  context "with error" do
    let(:response) do
      request = Hubspotter::Request.new(
        '/contacts/v1/contact',
        :post,
        post_body: { properties: [
          { property: :email, value: 'test@example.com' }]}.to_json)
      request.send
    end

    it "is not successful" do
      VCR.use_cassette('response-create-error') do
        expect(response.success?).to eq(false)
      end
    end

    it "returns a error string" do
      VCR.use_cassette('response-create-error') do
        expect(response.error_message).to match(/CONTACT_EXISTS/)
      end
    end
  end
end
