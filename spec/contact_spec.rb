require "spec_helper"
require "hubspotter/contact"
require "hubspotter/exception"

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

    describe "#create" do
      it "creates a new contact" do
        VCR.use_cassette('contact-create') do
          contact = Hubspotter::Contact.create({
              first_name: 'Test',
              last_name: 'Person',
              email: 'totallynewuser@example.com' })
          expect(contact['canonical-vid']).to eq 231258
        end
      end

      context "duplicate user" do
        let(:contact) do
          Hubspotter::Contact.create({ email: 'test@example.com' })
        end

        it "raises HubspotError" do
          VCR.use_cassette('contact-create-duplicate') do
            expect{contact}.to raise_error(Hubspotter::HubspotError)
          end
        end
      end
    end

    describe "#update" do
      let(:contact) do
        Hubspotter::Contact.update(
          231258,
          { email: 'updateemail@example.com' })
      end

      it "updates properties" do
        VCR.use_cassette('contact-update') do
          expect(contact.properties.email).to eq('updateemail@example.com')
        end
      end
    end
  end
end
