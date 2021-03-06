require "spec_helper"
require "foundries/contact_foundry"
require "hubspotter/contact"
require "hubspotter/exception"

describe Hubspotter::Contact do
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
          vid = Hubspotter::Contact.create(
            ContactFoundry.default_properties)
          expect(vid).to eq ContactFoundry.default_vid
        end
      end

      context "duplicate user" do
        let(:contact_data) do
          Hubspotter::Contact.create(ContactFoundry.duplicate_email_properties)
        end

        it "raises HubspotError" do
          VCR.use_cassette('contact-create-duplicate') do
            expect{contact_data}.to raise_error(Hubspotter::HubspotError)
          end
        end
      end
    end

    describe "#update" do
      let(:contact_data) do
        Hubspotter::Contact.update(
          ContactFoundry.default_vid,
          ContactFoundry.default_properties({ email: 'updated@example.com' }))
      end

      it "updates properties" do
        VCR.use_cassette('contact-update') do
          expect(contact_data).to eq(true)
        end
      end
    end
  end
end
