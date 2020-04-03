require 'spec_helper'

describe "Server" do
  it "returns success accessing root path" do
    get '/'
    expect(last_response).to be_ok
  end

  describe "given no application is created" do
    describe "than fetching application" do
      before :each do
        get "/applications/xxxx"
      end

      it { expect(last_response.status).to eql(404) }
    end
  end

  describe "given application is submited" do
    before :each do
      post '/applications'
      @id = JSON.parse(last_response.body)['id']
    end

    describe "than fetching application" do
      before :each do
        get "/applications/#{@id}"
      end

      it { expect(last_response.status).to eql(200) }
      it { expect(JSON.parse(last_response.body)["title"]).to eql("TITLE") }
      it { expect(JSON.parse(last_response.body)["status"]).to eql("submited") }
    end

    describe "when application is accepted" do
      before :each do
        post "/applications/#{@id}/accept"
      end

      describe "then fetching application" do
        before :each do
          get "/applications/#{@id}"
        end

        it { expect(last_response.status).to eql(200) }
        it { expect(JSON.parse(last_response.body)["status"]).to eql("accepted") }
      end
    end

    describe "when application is rejected" do
      before :each do
        post "/applications/#{@id}/reject"
      end

      describe "then fetching application" do
        before :each do
          get "/applications/#{@id}"
        end

        it { expect(last_response.status).to eql(200) }
        it { expect(JSON.parse(last_response.body)["status"]).to eql("rejected") }
      end
    end
  end
end
