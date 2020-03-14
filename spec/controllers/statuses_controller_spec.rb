require 'rails_helper'
require 'spec_helper'

RSpec.describe StatusesController, type: :controller do

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
    it "assigns all statuses as @statuses" do
      status = Status.create! valid_attributes
      get :index, params: {}
      expect(assigns(:statuses)).to eq([status])
    end
  end

  describe "GET #show" do
    it "assigns the requested status as @status" do
      status = Status.create! valid_attributes
      get :show, params: {id: status.to_param}
      expect(assigns(:status)).to eq(status)
    end
  end

  describe "GET #new" do
    it "assigns a new status as @status" do
      get :new, params: {}
      expect(assigns(:status)).to be_a_new(Status)
    end
  end

  describe "GET #edit" do
    it "assigns the requested status as @status" do
      status = Status.create! valid_attributes
      get :edit, params: {id: status.to_param}
      expect(assigns(:status)).to eq(status)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Status" do
        expect {
          post :create, params: {status: valid_attributes}
        }.to change(Status, :count).by(1)
      end

      it "assigns a newly created status as @status" do
        post :create, params: {status: valid_attributes}
        expect(assigns(:status)).to be_a(Status)
        expect(assigns(:status)).to be_persisted
      end

      it "redirects to the created status" do
        post :create, params: {status: valid_attributes}
        expect(response).to redirect_to(Status.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved status as @status" do
        post :create, params: {status: invalid_attributes}
        expect(assigns(:status)).to be_a_new(Status)
      end

      it "re-renders the 'new' template" do
        post :create, params: {status: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      it "updates the requested status" do
        status = Status.create! valid_attributes
        put :update, params: {id: status.to_param, status: new_attributes}
        status.reload
        expect(assigns(:status).name).to eq("Low")
      end

      it "assigns the requested status as @status" do
        status = Status.create! valid_attributes
        put :update, params: {id: status.to_param, status: valid_attributes}
        expect(assigns(:status)).to eq(status)
      end

      it "redirects to the status" do
        status = Status.create! valid_attributes
        put :update, params: {id: status.to_param, status: valid_attributes}
        expect(response).to redirect_to(status)
      end
    end

    context "with invalid params" do
      it "assigns the status as @status" do
        status = Status.create! valid_attributes
        put :update, params: {id: status.to_param, status: invalid_attributes}
        expect(assigns(:status)).to eq(status)
      end

      it "re-renders the 'edit' template" do
        status = Status.create! valid_attributes
        put :update, params: {id: status.to_param, status: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested status" do
      status = Status.create! valid_attributes
      expect {
        delete :destroy, params: {id: status.to_param}
      }.to change(Status, :count).by(-1)
    end

    it "redirects to the statuses list" do
      status = Status.create! valid_attributes
      delete :destroy, params: {id: status.to_param}
      expect(response).to redirect_to(statuses_url)
    end

    it "fails to destroy status with dependent task" do
      status = Status.create! valid_attributes
      FactoryBot.create(:task, reported_by: @admin, status: status)
      delete :destroy, params: {id: status.to_param}
      expect(assigns(:status).errors.messages[:base]).to match(["Cannot delete record because dependent tasks exist"])
    end
  end

end
