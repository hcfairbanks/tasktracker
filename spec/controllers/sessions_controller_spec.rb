require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before(:each) {
      @admin = User.new
      @admin.first_name = 'John'
      @admin.last_name  = 'Doe'
      @admin.password   = '123456'
      @admin.email = 'testadmin@test.com'
      @admin.role   = Role.find_by_name('admin')
      @admin.avatar = Rails.root.join('spec/fixtures/binaries/headshots/1.jpg').open
      @admin.save!
    }
    it 'creates new session_id' do
      post :create, params: { password: @admin.password, email: @admin.email }
      expect(session[:user_id]).to eq(@admin.id)
    end
    it 'redirects to tasks index' do
      post :create, params: { password: @admin.password, email: @admin.email }
      expect(response).to redirect_to(tasks_url)
    end
    it 'displays correct login message' do
      post :create, params: { password: @admin.password, email: @admin.email }
      expect(flash[:notice]).to match('Logged in!')
    end

    context 'rejects bad login' do
      it 'does not create session_id' do
        post :create, params: { password: 'bad', email: 'bad@bad.com' }
        expect(session[:user_id]).to eq(nil)
      end
      it 'redirects to tasks index' do
        post :create, params: { password: 'bad', email: 'bad@bad.com' }
        expect(response).to render_template(:new)
      end
      it 'displays correct error message' do
        post :create, params: { password: 'bad', email: 'bad@bad.com' }
        expect(flash[:alert]).to match('Email or password is invalid')
      end
    end
    context 'rejects unassigned user login' do
      before(:each) {
        @unassigned = User.new
        @unassigned.first_name = 'John'
        @unassigned.last_name  = 'Doe'
        @unassigned.password   = '123456'
        @unassigned.email = 'test+unassigned@test.com'
        @unassigned.role   = Role.find_by_name('unassigned')
        @unassigned.avatar = Rails.root.join('spec/fixtures/binaries/headshots/1.jpg').open
        @unassigned.save!
      }
      it 'does not create session_id' do
        post :create, params: { password: @unassigned.password, email: @unassigned.email }
        expect(session[:user_id]).to eq(nil)
      end
      it 'redirects to tasks index' do
        post :create, params: { password: 'bad', email: 'bad@bad.com' }
        expect(response).to render_template(:new)
      end
      it 'displays correct error message' do
        post :create, params: { password: 'bad', email: 'bad@bad.com' }
        expect(flash[:alert]).to match('Email or password is invalid')
      end
    end

  end

  describe "POST #destroy" do
    before(:each) {
      @admin = User.new
      @admin.first_name = 'John'
      @admin.last_name = 'Doe'
      @admin.password = '123456'
      @admin.email = 'testadmin@test.com'
      @admin.role = Role.find_by_name('admin')
      @admin.avatar = Rails.root.join('spec/fixtures/binaries/headshots/1.jpg').open
      @admin.save!
    }
    it 'destroies new session_id' do
      post :create, params: { password: @admin.password, email: @admin.email }
      expect(session[:user_id]).to eq(@admin.id)
      post :destroy, params: {}
      expect(session[:user_id]).to eq(nil)
    end
    it 'redirects to new sessions' do
      post :create, params: { password: @admin.password, email: @admin.email }
      post :destroy, params: {}
      expect(response).to redirect_to(root_url)
    end
    it 'displays correct logout message' do
      post :create, params: { password: @admin.password, email: @admin.email }
      post :destroy, params: {}
      expect(flash[:notice]).to match('Logged out!')
    end
  end
end
