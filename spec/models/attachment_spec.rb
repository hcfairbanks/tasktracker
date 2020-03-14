require 'rails_helper'
# https://til.codes/testing-carrierwave-file-uploads-with-rspec-and-factorygirl/
RSpec.describe Attachment, type: :model do
  let(:user_role){FactoryBot.build(:role,{name:'user'})}
  let(:user_bob){FactoryBot.build(:user)}
  let(:task_object){FactoryBot.build(:task,reported_by:user_bob)}

  let(:valid_attributes){
    {
      doc: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/binaries/headshots/2.jpg'))),
      original_name: "2.jpg",
      priority: 2,
      task: task_object
    }
  }

  let(:invalid_no_doc){
    {
      doc: "",
      task: task_object
    }
  }

  let(:large_file){
    {
      doc: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/binaries/large_files/hotu.cbz'))),
      original_name: "hotu.cbz",
      priority: 3,
      task: task_object
    }
  }

  describe "creation" do
    it "is valid with doc" do
      attachment_object = Attachment.create(valid_attributes)
      expect(attachment_object.original_name).to eq("2.jpg")
      expect(attachment_object).to be_valid
    end

    it "is invalid with large file" do
      attachment_object = Attachment.create(large_file)
      expect(attachment_object.errors.messages[:doc]).to eq(["Attachment size exceeds the allowable limit (25 MB)."])
      expect(attachment_object).to be_invalid
    end

    it "is invalid without a doc" do
      attachment_object = Attachment.create(invalid_no_doc)
      expect(attachment_object.errors.messages[:doc]).to eq(["can't be blank"])
      expect(attachment_object).to be_invalid
    end

    it "is haulted because too many attachments on a task" do
      too_many_attachments = Task::MAX_ATTACHMENTS + 1
      too_many_attachments.times do
        Attachment.create(valid_attributes)
      end
      expect(task_object.attachments.length).to eq(Task::MAX_ATTACHMENTS)
    end

  end
end
