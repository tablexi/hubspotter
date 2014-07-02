require "spec_helper"
require "foundries/form_foundry"
require "hubspotter/form"

describe Hubspotter::Form do
  describe "class methods" do
    describe "#submit" do
      let(:portal_id){ FormFoundry.default_portal_id }
      let(:guid){ FormFoundry.default_guid }
      let(:form_data){ FormFoundry.default_form_data }
      let(:context_data){ FormFoundry.default_context_data }


      it "returns true on successful submission" do
        Hubspotter.configuration.portal_id = portal_id
        VCR.use_cassette('form-submit') do
          response = Hubspotter::Form.submit(
            guid,
            form_data: form_data,
            context_data: context_data)
          expect(response).to eq(true)
        end
        Hubspotter.reset
      end
    end
  end
end



