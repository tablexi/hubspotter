require "spec_helper"
require "hubspotter/exception"
require "hubspotter/request"

describe Hubspotter::Request do
  describe "class method" do
    describe "#initialize" do

      let(:request) do
        Hubspotter::Request.new(
          '/path',
          :get,
          url_params: { key: 'value' },
          post_body: 'body')
      end

      it "sets path" do
        expect(request.path).to eq('/path')
      end

      it "sets method" do
        expect(request.method).to eq(:get)
      end

      it "sets url_params" do
        expect(request.url_params).to eq({ key: 'value' })
      end

      it "sets post_body" do
        expect(request.post_body).to eq('body' )
      end
    end
  end

  describe "instance method" do
    let(:request) do
      Hubspotter::Request.new("/contacts/v1/lists/all/contacts/all", :get)
    end

    describe ".send" do
      context "bad request" do
        it "raises AuthorizationError" do
          Hubspotter.configuration.api_key = 'invalid'
          VCR.use_cassette('request-invalid-key') do
            expect{request.send}.to raise_error(Hubspotter::AuthorizationError)
          end
          Hubspotter.reset
        end

        it "raises InvalidPath" do
          request.path = '/foo'
          VCR.use_cassette('request-invalid-path') do
            expect{request.send}.to raise_error(Hubspotter::InvalidPath)
          end
        end
      end
    end

    describe ".method=" do
      it "validates method" do
        expect{request.method = :foo}.to  raise_error(Hubspotter::InvalidMethod)
        expect(request.method = :get).to  eq :get
        expect(request.method = :post).to eq :post
      end
    end
  end
end
