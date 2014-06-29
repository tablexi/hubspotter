require "spec_helper"
require "foundries/request_foundry"
require "hubspotter/exception"

describe Hubspotter::Request do
  describe "class method" do
    describe "#initialize" do
      let(:request){ RequestFoundry.default }

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
    let(:request){ RequestFoundry.get_contacts }

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

        it "raises ConnectionError" do
          VCR.use_cassette('request-connection-error') do
            request = RequestFoundry.update_contact
            expect{request.send}.to raise_error(Hubspotter::ConnectionError)
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
