require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user_role){FactoryBot.create(:role,{name:'user'})}
  let(:user_bob){FactoryBot.create(:user)}

  let(:valid_attributes){
    {
      reported_by: user_bob,
      assigned_to: user_bob,
      required_by: DateTime.now,
      description: "Some task."
    }
  }

  let(:valid_attachment_attributes){
    {
      reported_by: user_bob,
      assigned_to: user_bob,
      required_by: DateTime.now,
      description: "Some task.",
      attachments_attributes:[
        {doc: Rack::Test::UploadedFile.new(
          File.open(File.join(Rails.root, '/spec/fixtures/binaries/headshots/2.jpg'
        ))),
        original_name:"2.jpg",
        priority: 5
        }]
    }
  }

  let(:no_reporter_attributes){
    {
      description: "Some task.",
      required_by: DateTime.now,
      attachments_attributes:[
        {doc: Rack::Test::UploadedFile.new(
          File.open(File.join(Rails.root, '/spec/fixtures/binaries/headshots/2.jpg'
        ))),
        original_name:"2.jpg",
        priority: 5
        }]
    }
  }

  let(:no_description_attributes){
    {
      reported_by: user_bob,
      required_by: DateTime.now,
      attachments_attributes:[
        {doc: Rack::Test::UploadedFile.new(
          File.open(File.join(Rails.root, '/spec/fixtures/binaries/headshots/2.jpg'
        ))),
        original_name:"2.jpg",
        priority: 5
        }]
    }
  }

  let(:no_required_by_attributes){
    {
      reported_by: user_bob,
      description: "Some task.",
      attachments_attributes:[
        {doc: Rack::Test::UploadedFile.new(
          File.open(File.join(Rails.root, '/spec/fixtures/binaries/headshots/2.jpg'
        ))),
        original_name:"2.jpg",
        priority: 5
        }]
    }
  }

  describe "creation" do
    it "is valid with reporter and description" do
      task_object = Task.create(valid_attributes)
      expect(task_object.reported_by.first_name).to eq("Bob")
      expect(task_object.description).to eq("Some task.")
    end

    it "is invalid without reporter" do
      task_object = Task.create(no_reporter_attributes)
      expect(task_object).to be_invalid
    end
    it "is invalid without description" do
      task_object = Task.create(no_reporter_attributes)
      expect(task_object).to be_invalid
    end
    it "is invalid without required_by" do
      task_object = Task.create(no_required_by_attributes)
      expect(task_object).to be_invalid
    end
  end
end
