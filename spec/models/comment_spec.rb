require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user_role){FactoryBot.build(:role,{name:'user'})}
  let(:user_bob){FactoryBot.build(:user)}
  let(:task_object){FactoryBot.build(:task,reported_by:user_bob)}

  let(:valid_attributes){
    {
      task: task_object,
      user: user_bob,
      content: "Some content."
    }
  }

  let(:invalid_attributes){
    {
      content: ""
    }
  }

  let(:missing_task){
    {
      user: user_bob,
      content: "Some content."
    }
  }
  let(:missing_user){
    {
      task: task_object,
      content: "Some content."
    }
  }

  describe "creation" do
    it "is valid with content" do
      comment_object = Comment.create(valid_attributes)
      expect(comment_object.content).to eq("Some content.")
      expect(comment_object).to be_valid
    end

    it "is invalid without content" do
      comment_object = Comment.create(invalid_attributes)
      expect(comment_object.errors.messages[:content]).to eq(["can't be blank"])
      expect(comment_object).to be_invalid
    end

    it "is invalid without task" do
      comment_object = Comment.create(missing_task)
      expect(comment_object.errors.messages[:task]).to eq(["must exist", "can't be blank"])
      expect(comment_object).to be_invalid
    end

    it "is invalid without user" do
      comment_object = Comment.create(missing_user)
      expect(comment_object.errors.messages[:user]).to eq(["must exist", "can't be blank"])
      expect(comment_object).to be_invalid
    end

  end

end
