require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "renders new user template" do
      get :new
      expect(response).to render_template(:new)
    end

  end

  describe "POST #create" do
    context "with valid params" do
      it "signs user in" do
        post :create, params: { user: { username: 'jack_bruce', password: 'abcdef' } }
        user = User.find_by(username: 'jack_bruce')
        expect(session[:session_token]).to eq(user.session_token)
      end

      it 'redirects to links_url' do
        post :create, params: { user: { username: 'jack_bruce', password: 'abcdef'} }
        expect(response).to redirect_to(goals_url)
      end
    end

    context "with invalid params" do
      it "should render new template params" do
        post :create, params: { user: { username: 'jack_bruce', password: '' } }
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end
  end
end
