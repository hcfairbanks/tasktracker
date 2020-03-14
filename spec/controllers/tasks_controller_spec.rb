require 'rails_helper'
require 'spec_helper'

RSpec.describe TasksController, type: :controller do

  let!(:user_bob){FactoryBot.create(:user, first_name:"Bob", last_name:"Boberson", role_id: Role.find_by_name('admin').id)}
  let!(:priority_high){FactoryBot.create(:priority)}
  let!(:status_triage){FactoryBot.create(:status)}
  let!(:request_type_bug){FactoryBot.create(:request_type)}
  let!(:vertical_production){FactoryBot.create(:vertical)}
  let!(:task_test){FactoryBot.create(:task,reported_by: user_bob)}

  let(:valid_attributes) {
    {
      title: "test task",
      description: "test description",
      reported_by_id: user_bob.id,
      assigned_to_id: user_bob.id,
      status_id: status_triage.id,
      request_type_id: request_type_bug.id,
      member_facing: true,
      vertical_id: vertical_production.id,
      link: "www.testlink.com",
      required_by: Date.today,
      priority_id: priority_high.id,
      # Singular, image_attributes:{photo: fixture_file_upload('/binaries/dog_1.jpg','image/jpg', "true")}
      # Plural,   attachments_attributes:[ {doc: fixture_file_upload('/binaries/cars/2.jpg','image/jpg', "true")},{doc: fixture_file_upload('/binaries/cars/1.jpg','image/jpg', "true")}]
      attachments_attributes:[
        { doc: fixture_file_upload('/binaries/headshots/2.jpg','image/jpg', "true"),
                                    original_name: "2.jpg", priority: 2 },
        { doc: fixture_file_upload('/binaries/headshots/1.jpg','image/jpg', "true"),
                                    original_name: "1.jpg", priority: 1 }]
    }
  }

  let(:invalid_attributes) {
    {
      title: "test task update",
      description: "test description update",
      reported_by_id: "",
      assigned_to_id: user_bob.to_param,
      status_id: status_triage.to_param,
      request_type_id: request_type_bug.to_param,
      member_facing: true,
      vertical_id: vertical_production.to_param,
      link: "www.testlink.com",
      required_by: Date.today,
      priority_id: priority_high.to_param,
      attachments_attributes:[
                               { doc: fixture_file_upload("/binaries/headshots/2.jpg",
                                                          "image/jpg",
                                                          "true"),
                                 original_name: "2.jpg",
                                 priority: 2 },
                               { doc: fixture_file_upload("/binaries/headshots/1.jpg",
                                                          "image/jpg",
                                                          "true"),
                                 original_name: "1.jpg",
                                 priority: 1 }]
    }
  }

  let(:new_attributes) {
    {
      title: "test task update",
      description: "test task update",
      reported_by_id: user_bob.to_param,
      assigned_to_id: user_bob.to_param,
      status_id: status_triage.to_param,
      request_type_id: request_type_bug.to_param,
      member_facing: true,
      vertical_id: vertical_production.to_param,
      link: "www.testlink.com",
      required_by: Date.today,
      priority_id: priority_high.to_param,
      attachments_attributes:[
                               { doc: fixture_file_upload("/binaries/headshots/2.jpg",
                                                          "image/jpg",
                                                          "true"),
                                 original_name: "2.jpg",
                                 priority: 2 },
                               { doc: fixture_file_upload("/binaries/headshots/1.jpg",
                                                          "image/jpg",
                                                          "true"),
                                 original_name: "1.jpg",
                                 priority: 1 }]
    }
  }

  before(:each){
    @admin = admin_login
  }

  describe "GET #index" do
    it "renders the :index template" do
      get :index
      expect(response).to render_template("index")
    end
    it "assign all tasks as @tasks" do
      get :index
      task_object = Task.create! valid_attributes
      expect(assigns(:tasks)).to include(task_object)
    end
  end

  describe "GET #show" do
    it "assigns the requested task as @task" do
      task_object = Task.create! valid_attributes
      get :show, params: {id: task_object.to_param}
      expect(assigns(:task)).to eq(task_object)
    end
    it "renders the show template" do
      task_object = Task.create! valid_attributes
      get :show, params: {id: task_object.to_param}
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    it "assigns a new task as @task" do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    it "assigns the requested task as @task" do
      task_object = Task.create! valid_attributes
      get :edit, params: {id: task_object.to_param}
      expect(assigns(:task)).to eq(task_object)
    end
    it "renders the edit template" do
      task_object = Task.create! valid_attributes
      get :edit, params: {id: task_object.to_param}
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do

    before(:each){
        allow_any_instance_of(Task).to receive(:send_slack).and_return(true)
    }

    context "with valid attributes" do
      it "saves the new task in the database" do
        expect { post :create, format: "json", params: {task: valid_attributes} }.to change(Task, :count).by(1)
      end
      it "creates valid model atttachment original_name" do
        post :create, params: {task: valid_attributes}
        expect(assigns(:task).attachments.first.original_name).to eq('1.jpg')
      end
      it "creates valid model atttachment priority" do
        post :create, params: {task: valid_attributes}
        expect(assigns(:task).attachments.first.priority).to eq(1)
      end
      it "responses with 201" do
        post :create, format: "json", params: {task: valid_attributes}
        expect(response).to have_http_status(201)
      end
      it "produces valid create flash message" do
        post :create, params: {task: valid_attributes}
        expect(flash[:notice]).to match("Task was successfully created.")
      end
    end

    context "with invalid attributes" do
      it "does not save the new task in the database" do
        expect { post :create, format: "json", params: {task: invalid_attributes}}.to change(Task, :count).by(0)
      end
      it "renders the :new template" do
        post :create, params: {task: invalid_attributes}
        expect(response).to render_template("new")
      end
      it "assigns 3 error message" do
        post :create, format: "json", params: {task: invalid_attributes}
        expect(assigns(:task).errors.size).to eq(3)
      end
      it "returns error messages reported_by 'can\'t be blank'" do
        post :create, format: "json", params: {task: invalid_attributes}
        expect(assigns(:task).errors.messages[:reported_by]).to match(["must exist", "can't be blank"])
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "updates the requested task" do
        task_object = Task.create! valid_attributes
        put :update, params: {id: task_object.to_param, task: new_attributes}
        expect(assigns(:task)).to be_valid
      end
      it "redirects to the task" do
        task_object = Task.create! valid_attributes
        put :update, params: {id: task_object.to_param, task: new_attributes}
        expect(response).to redirect_to(task_url(task_object.to_param))
      end
      it "produces valid update flash message" do
        task_object = Task.create! valid_attributes
        put :update, params: {id: task_object.to_param, task: new_attributes}
        expect(flash[:notice]).to match("Task was successfully updated.")
      end
    end
    context "with invalid attributes" do
      it "assigns the task as @task" do
        task_object = Task.create! valid_attributes
        put :update, params: {id: task_object.to_param, task:  invalid_attributes}
        expect(assigns(:task)).to eq(task_object)
      end
      it "returns error message reported_by 'can\'t be blank'" do
        task_object = Task.create(valid_attributes)
        put :update, params: {id: task_object.to_param, task:  invalid_attributes}
        expect(assigns(:task).errors.messages[:reported_by]).to eq(["must exist", "can't be blank"])
      end
      it "renders the edit template" do
        task_object = Task.create(valid_attributes)
        put :update, params: {id: task_object.to_param, task:  invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task_to_be_deleted = Task.create(valid_attributes)
      expect { delete :destroy, params: {id: task_to_be_deleted.to_param} }.to change(Task, :count).by(-1)
    end
    it "redirects to tasks" do
      task_to_be_deleted = Task.create(valid_attributes)
      delete :destroy, params: {id: task_to_be_deleted.to_param}
      expect(response).to redirect_to(tasks_url)
    end
    it "produces valid destroy flash message" do
      task_to_be_deleted = Task.create(valid_attributes)
      delete :destroy, params: {id: task_to_be_deleted.to_param}
      expect(flash[:notice]).to match("Task was successfully destroyed.")
    end
    it "deletes accociated task comments" do
      task_to_be_deleted = Task.create(valid_attributes)
      comment = Comment.create(user_id:user_bob.to_param,content:"something",task_id:task_to_be_deleted.to_param)
      expect{ delete :destroy, params: {id: task_to_be_deleted.to_param} }.to change(Comment, :count).by(-1)
    end
  end
end
