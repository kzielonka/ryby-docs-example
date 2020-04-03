require 'spec_helper'

resource "Applications" do
  explanation "Applications resource"
  header "Content-Type", "application/json"

  describe "given application is not submitted yet" do
    post "/applications" do
      example "Submit application" do
        do_request
        expect(status).to eq 201
      end
    end

    post "/applications/:id/accept" do
      let(:id) { "id" }

      example "Accept not submited application" do
        do_request
        expect(status).to eq 404
      end
    end
  end

  describe "give application is submitted" do
    before :each do
      post '/applications'
      @id = JSON.parse(last_response.body)["id"]
    end

    post "/applications/:id/accept" do
      let(:id) { @id }

      example "Accept submited application" do
        do_request
        expect(status).to eq 205
      end
    end
  end
end
