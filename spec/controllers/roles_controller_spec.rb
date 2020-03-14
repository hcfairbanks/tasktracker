require 'rails_helper'
require 'spec_helper'

RSpec.describe RolesController, type: :controller do

  before(:each){
    @admin = admin_login
  }

  let(:valid_attributes) {
    {
      name: "Test_Role",
      description: "Test Description"
    }
  }

  let(:invalid_attributes) {
    {
      name: ""
    }
   }

   let(:new_attributes) {
     {
       name: "Different_Test_Role",
       description: "Different Test Description"
     }
   }

  describe "GET #index" do
    it "assigns all roles as @roles" do
      role = Role.create! valid_attributes
      get :index, params: {}
      expect(assigns(:roles)).to include(role)
    end
  end

  describe "GET #show" do
    it "assigns the requested role as @role" do
      role = Role.create! valid_attributes
      get :show, params: {id: role.to_param}
      expect(assigns(:role)).to eq(role)
    end
  end

  describe "GET #new" do
    it "assigns a new role as @role" do
      get :new, params: {}
      expect(assigns(:role)).to be_a_new(Role)
    end
  end

  describe "GET #edit" do
    it "assigns the requested role as @role" do
      role = Role.create! valid_attributes
      get :edit, params: {id: role.to_param}
      expect(assigns(:role)).to eq(role)
    end
  end

  describe "POST #create" do
    context "with valid role" do
      it "creates a new role" do
        expect {
          post :create, params: {role: valid_attributes}
        }.to change(Role, :count).by(1)
      end

      it "assigns a newly created role as @role" do
        post :create, params: {role: valid_attributes}
        expect(assigns(:role)).to be_a(Role)
        expect(assigns(:role)).to be_persisted
      end

      it "redirects to the created role" do
        post :create, params: {role: valid_attributes}
        expect(response).to redirect_to(Role.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved role as @role" do
        post :create, params: {role: invalid_attributes}
        expect(assigns(:role)).to be_a_new(Role)
      end

      it "re-renders the 'new' template" do
        post :create, params: {role: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      it "updates the requested role" do
        role = Role.create! valid_attributes
        put :update, params: {id: role.to_param, role: new_attributes}
        role.reload
        expect(assigns(:role).name).to eq("Different_Test_Role")
      end

      it "assigns the requested role as @role" do
        role = Role.create! valid_attributes
        put :update, params: {id: role.to_param, role: valid_attributes}
        expect(assigns(:role)).to eq(role)
      end

      it "redirects to the role" do
        role = Role.create! valid_attributes
        put :update, params: {id: role.to_param, role: valid_attributes}
        expect(response).to redirect_to(role)
      end
    end

    context "with invalid params" do
      it "assigns the role as @role" do
        role = Role.create! valid_attributes
        put :update, params: {id: role.to_param, role: invalid_attributes}
        expect(assigns(:role)).to eq(role)
      end

      it "re-renders the 'edit' template" do
        role = Role.create! valid_attributes
        put :update, params: {id: role.to_param, role: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested role" do
      role = Role.create! valid_attributes
      expect {
        delete :destroy, params: {id: role.to_param}
      }.to change(Role, :count).by(-1)
    end

    it "redirects to the roles list" do
      role = Role.create! valid_attributes
      delete :destroy, params: {id: role.to_param}
      expect(response).to redirect_to(roles_url)
    end

    it "fails to destroy role with dependent user" do
      role = Role.create! valid_attributes
      FactoryBot.create(:user, role: role)
      delete :destroy, params: {id: role.to_param}
      expect(assigns(:role).errors.messages[:base]).to match(["Cannot delete record because dependent users exist"])
    end
  end

end
