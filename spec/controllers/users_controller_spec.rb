require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do

  let!(:user_bob){FactoryBot.create(:user, first_name:"Bob", last_name:"Boberson", role_id: Role.find_by_name('business').id)}

  before(:each){
    @admin = admin_login
  }
  let(:valid_attributes) {
    {
      first_name:"John",
      last_name:"Smith",
      email:"valid_attributes_test@test.com",
      password: 'password',
      password_confirmation: 'password',
      role_id: Role.find_by_name('business').id,
      avatar: fixture_file_upload('/binaries/headshots/3.jpg','image/jpg', "true")
    }
  }

  let(:invalid_attributes) {
    {
      email: "blah",
      role_id: nil
    }
  }

  let(:update_valid_attributes) {
    {
      first_name: "edit_first_name",
      last_name: "edit_last_name",
      email: "edit_valid_attributes_test@test.com",
      role_id: Role.find_by_name('business').id,
      avatar: fixture_file_upload('/binaries/headshots/2.jpg','image/jpg', "true")
    }
  }

  describe "GET #index users" do
    it "assign all users as @users" do
      get :index
      expect(assigns(:users)).to include(user_bob, @admin)
    end
    it "renders the :index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET images serve" do
    it "serve user thumnail avatar" do
      get :serve_small, params: {id: @admin.to_param}
      expect(response.header['Content-Type']).to eq("image/jpeg")
      expect(response.header['Content-Disposition']).to eq("inline; filename=\"small_1.jpg\"")
      expect(controller.headers["Content-Transfer-Encoding"]).to eq("binary")
    end
    it "serve user thumnail avatar" do
      get :serve_medium, params: {id: @admin.to_param}
      expect(response.header['Content-Type']).to eq("image/jpeg")
      expect(response.header['Content-Disposition']).to eq("inline; filename=\"medium_1.jpg\"")
      expect(controller.headers["Content-Transfer-Encoding"]).to eq("binary")
    end
    it "serve user thumnail avatar" do
      get :serve_large, params: {id: @admin.to_param}
      expect(response.header['Content-Type']).to eq("image/jpeg")
      expect(response.header['Content-Disposition']).to eq("inline; filename=\"1.jpg\"")
      expect(controller.headers["Content-Transfer-Encoding"]).to eq("binary")
    end
  end

  describe "GET #show user" do
    it "assigns users to @users" do
      get :show, params: {id: user_bob.to_param}
      expect(assigns(:user)).to eq(user_bob)
    end
    it "renders the :show template" do
      get :show, params: {id: user_bob.to_param}
      expect(response).to render_template("show")
    end
  end

  describe "GET #new user" do
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    it "renders the :new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit user" do
    it "assigns the requested user to @user" do
      get :edit, params: {id: user_bob.to_param}
      expect(assigns(:user)).to eq(user_bob)
    end
    it "renders the :edit template" do
      get :edit, params: {id: user_bob.to_param}
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create user" do

    context "with valid attributes" do
      it "saves the new user in the database" do
        expect { post :create, params: {user: valid_attributes} }.to change(User, :count).by(1)
      end
      it "redirects to users#show" do
        post :create, params: {user: valid_attributes}
        expect(response).to redirect_to(tasks_url)
      end
      it "saves the new user avatar" do
        post :create, params: {user: valid_attributes}
        expect(assigns(:user).avatar_identifier).to eq("3.jpg")
      end
      it "produces valid create flash message" do
        post :create, params: {user: valid_attributes}
        expect(flash[:notice]).to match('Account has been created.')
      end
    end

    context "with invalid attributes" do
      it "does not save the new user in the database" do
        expect { post :create, params: {user: invalid_attributes}}.to change(User, :count).by(0)
      end
      it "re-renders the :new template" do
        post :create, params: {user: invalid_attributes}
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update user" do

    context "with valid attributes" do
      it "updates the requested user" do
        put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
        expect(assigns(:user)).to be_valid
      end
      it "updates the requested users image" do
        put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
        expect(assigns(:user).avatar_identifier).to eq("2.jpg")
      end
      it "redirects to users#show" do
        put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
        expect(response).to redirect_to(user_bob)
      end
      it "produces valid update flash message" do
        put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
        expect(flash[:notice]).to match('User has been successfully updated.')
      end

    end

    context "with invalid attributes" do
      it "assigns the user" do
        put :update, params: { id: user_bob.to_param, user: invalid_attributes}
        user_bob.reload
        expect(user_bob.first_name).to eq("Bob")
      end
      it "user is not valid" do
        put :update, params: { id: user_bob.to_param, user: invalid_attributes}
        user_bob.reload
        expect(assigns(:user)).to_not be_valid
      end
      it "returns 1 error" do
        put :update, params: { id: user_bob.to_param, user: invalid_attributes}
        user_bob.reload
        expect(assigns(:user).errors.size).to eq(1)
      end
      it "redirects to users#edit" do
        put :update, params: {id: user_bob.to_param, user: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end

  end

   describe "DELETE #destroy" do
    it "destroys the requested user" do
      expect { delete :destroy, params: {id: user_bob.to_param} }.to change(User, :count).by(-1)
    end
    it "redirects admin to users#index" do
      delete :destroy, params: {id: user_bob.to_param}
      expect(response).to redirect_to(users_url)
    end
    it "user deletes self" do
      expect { delete :destroy, params: {id: @admin.to_param} }.to change(User, :count).by(-1)
    end
    it "ends user session when user deletes self" do
      delete :destroy, params: {id: @admin.to_param}
      expect(response).to redirect_to(root_url)
    end
    it "produces valid destroy flash message" do
      delete :destroy, params: {id: user_bob.to_param}
      expect(flash[:notice]).to match("User has been successfully deleted.")
    end
    it "fails to destroy user with dependent task" do
      FactoryBot.create(:task,reported_by:user_bob)
      delete :destroy, params: {id: user_bob.to_param}
      expect(assigns(:user).errors.messages[:base]).to match(["Cannot delete record because dependent reports exist"])
    end
    it "fails to destroy user with dependent comment" do
      task_object = FactoryBot.create(:task,reported_by:user_bob)
      FactoryBot.create(:comment,content: "stuff", user:user_bob, task: task_object)
      delete :destroy, params: {id: user_bob.to_param}
      expect(assigns(:user).errors.messages[:base]).to match(["Cannot delete record because dependent reports exist"])
    end

    it "destory the avatar" do
      get :destroy_avatar, params: {id: @admin.to_param}
      expect(assigns(:user).avatar_identifier).to eq(nil)
    end

  end

end
