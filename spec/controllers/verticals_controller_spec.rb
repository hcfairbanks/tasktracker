require 'rails_helper'
require 'spec_helper'

RSpec.describe VerticalsController, type: :controller do

  let(:user_bob){FactoryBot.build(:user, first_name:"Bob", last_name:"Boberson", role_id: Role.find_by_name('business').id)}

  before(:each){
    @admin = admin_login
  }

  let(:valid_attributes) {
    {
      name: "High"
    }
  }

  let(:invalid_attributes) {
    {
      name: ""
    }
   }

   let(:new_attributes) {
     {
       name: "Low"
     }
   }

  describe "GET #index" do
    it "assigns all verticals as @verticals" do
      vertical = Vertical.create! valid_attributes
      get :index, params: {}
      expect(assigns(:verticals)).to eq([vertical])
    end
  end

  describe "GET #show" do
    it "assigns the requested vertical as @vertical" do
      vertical = Vertical.create! valid_attributes
      get :show, params: {id: vertical.to_param}
      expect(assigns(:vertical)).to eq(vertical)
    end
  end

  describe "GET #new" do
    it "assigns a new vertical as @vertical" do
      get :new, params: {}
      expect(assigns(:vertical)).to be_a_new(Vertical)
    end
  end

  describe "GET #edit" do
    it "assigns the requested vertical as @vertical" do
      vertical = Vertical.create! valid_attributes
      get :edit, params: {id: vertical.to_param}
      expect(assigns(:vertical)).to eq(vertical)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Vertical" do
        expect {
          post :create, params: {vertical: valid_attributes}
        }.to change(Vertical, :count).by(1)
      end

      it "assigns a newly created vertical as @vertical" do
        post :create, params: {vertical: valid_attributes}
        expect(assigns(:vertical)).to be_a(Vertical)
        expect(assigns(:vertical)).to be_persisted
      end

      it "redirects to the created vertical" do
        post :create, params: {vertical: valid_attributes}
        expect(response).to redirect_to(Vertical.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved vertical as @vertical" do
        post :create, params: {vertical: invalid_attributes}
        expect(assigns(:vertical)).to be_a_new(Vertical)
      end

      it "re-renders the 'new' template" do
        post :create, params: {vertical: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      it "updates the requested vertical" do
        vertical = Vertical.create! valid_attributes
        put :update, params: {id: vertical.to_param, vertical: new_attributes}
        vertical.reload
        expect(assigns(:vertical).name).to eq("Low")
      end

      it "assigns the requested vertical as @vertical" do
        vertical = Vertical.create! valid_attributes
        put :update, params: {id: vertical.to_param, vertical: valid_attributes}
        expect(assigns(:vertical)).to eq(vertical)
      end

      it "redirects to the vertical" do
        vertical = Vertical.create! valid_attributes
        put :update, params: {id: vertical.to_param, vertical: valid_attributes}
        expect(response).to redirect_to(vertical)
      end
    end

    context "with invalid params" do
      it "assigns the vertical as @vertical" do
        vertical = Vertical.create! valid_attributes
        put :update, params: {id: vertical.to_param, vertical: invalid_attributes}
        expect(assigns(:vertical)).to eq(vertical)
      end

      it "re-renders the 'edit' template" do
        vertical = Vertical.create! valid_attributes
        put :update, params: {id: vertical.to_param, vertical: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested vertical" do
      vertical = Vertical.create! valid_attributes
      expect {
        delete :destroy, params: {id: vertical.to_param}
      }.to change(Vertical, :count).by(-1)
    end

    it "redirects to the verticals list" do
      vertical = Vertical.create! valid_attributes
      delete :destroy, params: {id: vertical.to_param}
      expect(response).to redirect_to(verticals_url)
    end

    it "fails to destroy vertical with dependent task" do
      vertical = Vertical.create! valid_attributes
      FactoryBot.create(:task, reported_by: user_bob, vertical: vertical)
      delete :destroy, params: {id: vertical.to_param}
      expect(assigns(:vertical).errors.messages[:base]).to match(["Cannot delete record because dependent tasks exist"])
    end
  end

end
