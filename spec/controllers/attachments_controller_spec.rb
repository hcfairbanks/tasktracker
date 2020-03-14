require 'rails_helper'
require 'spec_helper'

RSpec.describe AttachmentsController, type: :controller do

  before(:each){
    @admin = admin_login
  }

  let!(:task_object){FactoryBot.create(:task, reported_by: @admin)}

  let(:valid_attributes) {
    {
      task_id: task_object.id,
      doc: fixture_file_upload('/binaries/headshots/2.jpg','image/jpg', "true"),
      original_name: "2.jpg",
      priority: 0
    }
  }
  let(:valid_file) {
    {
      task: task_object,
      doc: fixture_file_upload('/binaries/test_files/sample.csv','text/csv', "true"),
      original_name: "sample.csv",
      priority: 0

    }
  }

  let(:invalid_attributes) {
    {
      doc: "stuff"
    }
   }

   describe "GET #serve_doc" do
     it "response with thumbnail for image" do
       attachment_object = Attachment.create valid_attributes
       get :serve_thumb, params: {id:attachment_object.to_param}

       expect(response.header['Content-Type']).to eq("image/jpeg")
       expect(response.header['Content-Disposition']).to eq("inline; filename=\"thumb_#{attachment_object.original_name}\"")
       expect(controller.headers["Content-Transfer-Encoding"]).to eq("binary")
     end
     it "response with doc image" do
       attachment_object = Attachment.create valid_attributes
       get :serve_doc, params: {id:attachment_object.to_param,type:"doc"}

       expect(response.header['Content-Type']).to eq("image/jpeg")
       expect(response.header['Content-Disposition']).to eq("inline; filename=\"2.jpg\"")
       expect(controller.headers["Content-Transfer-Encoding"]).to eq("binary")
     end
     it "response with doc csv" do
       attachment_object = Attachment.create valid_file
       get :serve_doc, params: {id:attachment_object.to_param}

       expect(response.header['Content-Type']).to eq("text/csv")
       expect(response.header['Content-Disposition']).to eq("inline; filename=\"sample.csv\"")
       expect(controller.headers["Content-Transfer-Encoding"]).to eq("binary")
     end
     it "response with generic thumbnail for csv" do
       attachment_object = Attachment.create valid_file
       get :serve_thumb, params: {id:attachment_object.to_param}

       expect(response.header['Content-Type']).to eq("image/jpeg")
       expect(response.header['Content-Disposition']).to eq("inline; filename=\"thumb_sample.csv\"")
       expect(controller.headers["Content-Transfer-Encoding"]).to eq("binary")
     end
   end

   describe "POST Json #Create" do
     context "with valid attributes" do
       it "saves attachment to the db" do
        expect { post :create, format: "json",
          params: {attachment: valid_attributes} }.to change(Attachment, :count).by(1)
       end
    end
   end

   describe "GET #update_priorities" do
     it "updates the attachmenst priority attribute" do
      attachment_object_1 = Attachment.create(valid_attributes)
      attachment_object_2 = Attachment.create(valid_attributes)
      get :update_priorities, format:"json", params: {
          attachment: { priorities_list:{
                        "0": {id: attachment_object_1.id, priority: "0"},
                        "1": {id: attachment_object_2.id, priority: "1"}}}}
      attachment_object_1.reload
      attachment_object_2.reload
      expect(attachment_object_1.priority).to eq(0)
      expect(attachment_object_2.priority).to eq(1)
    end
    it "response with success" do
      attachment_object_1 = Attachment.create(valid_attributes)
      attachment_object_2 = Attachment.create(valid_attributes)
      get :update_priorities, format:"json", params: {
          attachment: { priorities_list:{
                         "0": {id: attachment_object_1.id, priority: "0"},
                         "1": {id: attachment_object_2.id, priority: "1"}}}}
      expect(response).to have_http_status(200)
    end
   end

   describe "DELETE #destroy" do
     it "destroys the requested attachment" do
      attachment_object = Attachment.create(valid_attributes)
       expect {
         delete :destroy, params: {id: attachment_object.to_param}
       }.to change(Attachment, :count).by(-1)
     end
     it "redirects to the task" do
        attachment_object = Attachment.create(valid_attributes)
        delete :destroy, params: {id: attachment_object.to_param}
        expect(response).to redirect_to(task_object)
      end
      context "with Json format," do
        it "destroys the requested attachment" do
         attachment_object = Attachment.create(valid_attributes)
          expect {
            delete :destroy,format: "json", params: {id: attachment_object.to_param}
          }.to change(Attachment, :count).by(-1)
        end
        it "responses with 200" do
          attachment_object = Attachment.create(valid_attributes)
          delete :destroy, format:"json", params: {id: attachment_object.to_param}
          expect(response).to have_http_status(200)
        end
      end
   end
 end
