require 'rails_helper'
require 'spec_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user_bob){FactoryBot.create(:user, first_name:"Bob", last_name:"Boberson", role_id: Role.find_by_name('business').id)}
  let(:task_user_bob){FactoryBot.create(:task,reported_by:user_bob)}

  before(:each){
    @admin = admin_login
  }

  let(:valid_attributes) {
    {
      content: "Some Comment",
      user_id: user_bob.id,
      task_id: task_user_bob.id
    }
  }

  let(:invalid_attributes) {
    {
      task: task_user_bob,
      content: ""
    }
   }

   let(:new_attributes) {
     {
       content: "Some New Comment",
       user: user_bob,
       task: task_user_bob
     }
   }

  describe "GET #index" do
    it "assigns all comments as @comments" do
      comment = Comment.create! valid_attributes
      get :index, params: {}
      expect(assigns(:comments)).to eq([comment])
    end
  end

  describe "GET #show" do
    it "assigns the requested comment as @comment" do
      comment = Comment.create! valid_attributes
      get :show, params: {id: comment.to_param}
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe "GET #new" do
    it "assigns a new comment as @comment" do
      get :new, params: {}
      expect(assigns(:comment)).to be_a_new(Comment)
    end
  end

  describe "GET #edit" do
    it "assigns the requested comment as @comment" do
      comment = Comment.create! valid_attributes
      get :edit, params: {id: comment.to_param}
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new comment" do
        expect {
          post :create, params: {comment: valid_attributes}
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, params: {comment: valid_attributes}
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end

      it "redirects to the created comment in task" do
        task_object = FactoryBot.create(:task, reported_by: @admin)
        post :create, params: {comment: {content:"stuff",user_id:user_bob.to_param,task_id: task_object.to_param}}
        task_anchor = "http://test.host/tasks/#{assigns(:comment).task.id}#comment_#{assigns(:comment).id}"
        expect(response).to redirect_to(task_anchor)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        task_object = FactoryBot.create(:task, reported_by: @admin)
        post :create, params: {comment: {user_id:user_bob.to_param,task_id: task_object.to_param}}
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        task_object = FactoryBot.create(:task, reported_by: @admin)
        post :create, params: {comment: {user_id:user_bob.to_param,task_id: task_object.to_param}}
        expect(response).to redirect_to(task_object)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      it "updates the requested comment" do
        comment = Comment.create! valid_attributes
        put :update, params: {id: comment.to_param, comment: new_attributes}
        comment.reload
        expect(assigns(:comment).content).to eq("Some New Comment")
      end

      it "assigns the requested comment as @comment" do
        comment = Comment.create! valid_attributes
        put :update, params: {id: comment.to_param, comment: valid_attributes}
        expect(assigns(:comment)).to eq(comment)
      end

      it "redirects to the task" do
        comment = Comment.create! valid_attributes
        put :update, params: {id: comment.to_param, comment: valid_attributes}
        task_anchor = "http://test.host/tasks/#{comment.task.id}#comment_#{comment.id}"
        expect(response).to redirect_to(task_anchor)
      end
    end

    context "with invalid params" do
      it "assigns the comment as @comment" do
        comment = Comment.create! valid_attributes
        put :update, params: {id: comment.to_param, comment: invalid_attributes}
        expect(assigns(:comment)).to eq(comment)
      end

      it "re-renders the 'edit' template" do
        comment = Comment.create! valid_attributes
        put :update, params: {id: comment.to_param, comment: invalid_attributes}
        task_anchor = "http://test.host/tasks/#{comment.task.id}?alert=Content+can%27t+be+blank.+#comment_#{comment.id}"
        expect(response).to redirect_to(task_anchor)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do
      comment = Comment.create! valid_attributes
      expect {
        delete :destroy, params: {id: comment.to_param}
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the task" do
      comment = Comment.create! valid_attributes
      task = Task.find(comment.task.id)
      delete :destroy, params: {id: comment.to_param}
      expect(response).to redirect_to(task)
    end

  end

end
