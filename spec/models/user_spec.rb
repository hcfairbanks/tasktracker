require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_role){FactoryBot.build(:role,{name:'user'})}
  let(:user_bob){FactoryBot.build(:user,role_id:user_role.id)}

  let(:valid_attributes){
    {
      first_name: "Chris",
      last_name: "Boberson",
      email: "test@test.com",
      password:"hello_world",
      avatar: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/binaries/headshots/2.jpg')))
    }
  }

  let(:invalid_attributes){
    {
      email: "",
      password:""
    }
  }

  let(:invalid_email){
    {
      first_name: "Chris",
      last_name: "Boberson",
      email: "bob",
      password:"hello_world"
    }
  }

  let(:invalid_pw){
    {
      first_name: "Chris",
      last_name: "Boberson",
      email: "bob@bob.com",
      password:"hel"
    }
  }

  describe "creation" do
    it "is valid with first_name, last_name, email, and password" do
      user_object = User.create(valid_attributes)
      expect(user_object.email).to eq("test@test.com")
      expect(user_object).to be_valid
    end

    it "is invalid with invalid email and password" do
      user_object = User.create(invalid_email)
      expect(user_object.errors.messages[:email]).to eq(["is invalid"])
      expect(user_object).to be_invalid
    end

    it "is invalid with short password" do
      user_object = User.create(invalid_email)
      expect(user_object.errors.messages[:email]).to eq(["is invalid"])
      expect(user_object).to be_invalid
    end

    it "is invalid without name" do
      user_object = User.create(invalid_attributes)
      expect(user_object.errors.messages[:first_name]).to eq([" must contain only letters.", "is invalid"])
      expect(user_object).to be_invalid
    end
  end

end
