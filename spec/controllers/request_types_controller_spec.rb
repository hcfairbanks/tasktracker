require 'rails_helper'
require 'spec_helper'

RSpec.describe RequestTypesController, type: :controller do

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
    it "assigns all request_types as @request_type" do
      request_types = RequestType.create! valid_attributes
      get :index, params: {}
      expect(assigns(:request_types)).to eq([request_types])
    end
  end

  describe "GET #show" do
    it "assigns the requested request_type as @request_type" do
      request_types = RequestType.create! valid_attributes
      get :show, params: {id: request_types.to_param}
      expect(assigns(:request_type)).to eq(request_types)
    end
  end

  describe "GET #new" do
    it "assigns a new request_type as @request_type" do
      get :new, params: {}
      expect(assigns(:request_type)).to be_a_new(RequestType)
    end
  end

  describe "GET #edit" do
    it "assigns the requested request_type as @request_type" do
      request_type = RequestType.create! valid_attributes
      get :edit, params: {id: request_type.to_param}
      expect(assigns(:request_type)).to eq(request_type)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Request_Type" do
        expect {
          post :create, params: {request_type: valid_attributes}
        }.to change(RequestType, :count).by(1)
      end

      it "assigns a newly created request_type as @request_type" do
        post :create, params: {request_type: valid_attributes}
        expect(assigns(:request_type)).to be_a(RequestType)
        expect(assigns(:request_type)).to be_persisted
      end

      it "redirects to the created request_type" do
        post :create, params: {request_type: valid_attributes}
        expect(response).to redirect_to(RequestType.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved request_type as @request_type" do
        post :create, params: {request_type: invalid_attributes}
        expect(assigns(:request_type)).to be_a_new(RequestType)
      end

      it "re-renders the 'new' template" do
        post :create, params: {request_type: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      it "updates the requested request_type" do
        request_type = RequestType.create! valid_attributes
        put :update, params: {id: request_type.to_param, request_type: new_attributes}
        request_type.reload
        expect(assigns(:request_type).name).to eq("Low")
      end

      it "assigns the requested request_type as @request_type" do
        request_type = RequestType.create! valid_attributes
        put :update, params: {id: request_type.to_param, request_type: valid_attributes}
        expect(assigns(:request_type)).to eq(request_type)
      end

      it "redirects to the request_type" do
        request_type = RequestType.create! valid_attributes
        put :update, params: {id: request_type.to_param, request_type: valid_attributes}
        expect(response).to redirect_to(request_type)
      end
    end

    context "with invalid params" do
      it "assigns the request_type as @request_type" do
        request_type = RequestType.create! valid_attributes
        put :update, params: {id: request_type.to_param, request_type: invalid_attributes}
        expect(assigns(:request_type)).to eq(request_type)
      end

      it "re-renders the 'edit' template" do
        request_type = RequestType.create! valid_attributes
        put :update, params: {id: request_type.to_param, request_type: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested request_type" do
      request_type = RequestType.create! valid_attributes
      expect {
        delete :destroy, params: {id: request_type.to_param}
      }.to change(RequestType, :count).by(-1)
    end

    it "redirects to the priorities list" do
      request_type = RequestType.create! valid_attributes
      delete :destroy, params: {id: request_type.to_param}
      expect(response).to redirect_to(request_types_url)
    end

    it "fails to destroy priority with dependent task" do
      request_type = RequestType.create! valid_attributes
      FactoryBot.create(:task, reported_by: @admin, request_type: request_type)
      delete :destroy, params: {id: request_type.to_param}
      expect(assigns(:request_type).errors.messages[:base]).to match(["Cannot delete record because dependent tasks exist"])
    end
  end

end
