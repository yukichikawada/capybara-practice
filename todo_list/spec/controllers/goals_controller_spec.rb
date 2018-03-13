require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:jill) { User.create!(username: 'jill', password: 'abcdef') }

  describe "GET #new" do
    get :new
    expect(response).to render_template(:new)
  end


  describe "POST #create" do
    context "while logged in" do

      context "with valid params" do
        it "creates new goal" do
          post :create, params: { goal: { task: 'run more', body: 'get some exercise'}}
          goal = Goal.find_by(task: 'run more')
          expect(goal.task).to eq('run more')
        end
      end

      context "with invalid params" do
        post :create, params: { goal: { task: 'run more', body: 'get some exercise'}}
        goal = Goal.find_by(task: 'run more')
        expect(goal).to be_nil
      end
    end


    # create goal form not visible when logged out
  end

  describe 'GET #show' do
    bob_with_run
    context 'when logged in' do
      before do
        allow(controller).to receive(:current_user) { jill }
      end

      it 'renders the link show page' do
        get :show, params: { id: bob_goal.id }
        expect(response).to render_template('show')
      end
    end
    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        get :show, params: { id: bob_goal.id }
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'GET #edit' do
    context 'when logged in' do
      before do
        allow(controller).to receive(:current_user) { jill }
        @goal = Goal.create(
          task: 'sleep more',
          body: 'good for the brain',
          user: jill
        )
      end

      it "renders the edit goal page" do
        get :edit, params: { id: @goal.id }
        expect(resposne).to render_template('edit')
      end
    end

    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
        get :new, params: { goal: {} }
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'GET #index' do
    context 'when logged in' do
      before do
        allow(controller).to receive(:current_user) { bob }
      end

      it 'renders the new links page' do
        get :index
        expect(response).to render_template('index')
      end
    end

    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to(new_session_url)
      end
    end
  end


  describe "PATCH #update" do
    bob_with_run

    context 'when logged in as a different user' do
      before do
        allow(controller).to receive(:current_user) { bob }
      end

      it "should not allow users to update another users goals" do
        begin
          patch :update, params: { id: bob_goal.id, goal: { task: 'run more and sleep more'} }
        rescue ActiveRecord::RecordNotFound
      end

      updated_goal = Goal.find(bob_goal.id)
      expect(updated_goal.task).to eq('run more and sleep more')
    end

    context "when logged in as correct user" do
      before do
        allow(controller).to receive(:current_user) { bob }
      end

      it 'should allow users to update their goals'
        patch :update, params: { id: bob_goal.id, goal: { task: 'run more and sleep'} }
        updated_goal = Goal.find(bob_goal.id)
        expect(updated_goal.task).to eq('run more and sleep')
      end
    end
  end
end
