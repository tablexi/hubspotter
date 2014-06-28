require "spec_helper"
require "hubspotter/contact"

describe Hubspotter::Contact do
  before(:all) do
    Hubspotter.configure do |config|
      config.api_key = 'demo'
    end
  end

  describe "class methods" do
    describe "#all" do
      let(:contacts) { Hubspotter::Contact.all }

      it "returns an array of contacts" do
        VCR.use_cassette('contact-all') do
          expect(contacts.count).to eq(20)
        end
      end
    end
  end
end
