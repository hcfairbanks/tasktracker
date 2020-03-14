require 'rails_helper'
require 'spec_helper'

RSpec.describe PrioritiesController, type: :controller do

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
    it "assigns all priorities as @priorities" do
      priority = Priority.create! valid_attributes
      get :index, params: {}
      expect(assigns(:priorities)).to eq([priority])
    end
  end

  describe "GET #show" do
    it "assigns the requested priority as @priority" do
      priority = Priority.create! valid_attributes
      get :show, params: {id: priority.to_param}
      expect(assigns(:priority)).to eq(priority)
    end
  end

  describe "GET #new" do
    it "assigns a new priority as @priority" do
      get :new, params: {}
      expect(assigns(:priority)).to be_a_new(Priority)
    end
  end

  describe "GET #edit" do
    it "assigns the requested priority as @priority" do
      priority = Priority.create! valid_attributes
      get :edit, params: {id: priority.to_param}
      expect(assigns(:priority)).to eq(priority)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Priority" do
        expect {
          post :create, params: {priority: valid_attributes}
        }.to change(Priority, :count).by(1)
      end

      it "assigns a newly created priority as @priority" do
        post :create, params: {priority: valid_attributes}
        expect(assigns(:priority)).to be_a(Priority)
        expect(assigns(:priority)).to be_persisted
      end

      it "redirects to the created priority" do
        post :create, params: {priority: valid_attributes}
        expect(response).to redirect_to(Priority.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved priority as @priority" do
        post :create, params: {priority: invalid_attributes}
        expect(assigns(:priority)).to be_a_new(Priority)
      end

      it "re-renders the 'new' template" do
        post :create, params: {priority: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      it "updates the requested priority" do
        priority = Priority.create! valid_attributes
        put :update, params: {id: priority.to_param, priority: new_attributes}
        priority.reload
        expect(assigns(:priority).name).to eq("Low")
      end

      it "assigns the requested priority as @priority" do
        priority = Priority.create! valid_attributes
        put :update, params: {id: priority.to_param, priority: valid_attributes}
        expect(assigns(:priority)).to eq(priority)
      end

      it "redirects to the priority" do
        priority = Priority.create! valid_attributes
        put :update, params: {id: priority.to_param, priority: valid_attributes}
        expect(response).to redirect_to(priority)
      end
    end

    context "with invalid params" do
      it "assigns the priority as @priority" do
        priority = Priority.create! valid_attributes
        put :update, params: {id: priority.to_param, priority: invalid_attributes}
        expect(assigns(:priority)).to eq(priority)
      end

      it "re-renders the 'edit' template" do
        priority = Priority.create! valid_attributes
        put :update, params: {id: priority.to_param, priority: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested priority" do
      priority = Priority.create! valid_attributes
      expect {
        delete :destroy, params: {id: priority.to_param}
      }.to change(Priority, :count).by(-1)
    end

    it "redirects to the priorities list" do
      priority = Priority.create! valid_attributes
      delete :destroy, params: {id: priority.to_param}
      expect(response).to redirect_to(priorities_url)
    end

    it "fails to destroy priority with dependent task" do
      priority = Priority.create! valid_attributes
      FactoryBot.create(:task, reported_by: @admin, priority: priority)
      delete :destroy, params: {id: priority.to_param}
      expect(assigns(:priority).errors.messages[:base]).to match(["Cannot delete record because dependent tasks exist"])
    end
  end

end
