require 'rails_helper'

RSpec.describe Status, type: :model do
  let(:user_role){FactoryBot.build(:role,{name:'user'})}
  let(:user_bob){FactoryBot.build(:user,role_id:user_role.id)}

  let(:valid_attributes){
    {
      name: "Some name here.",
      description: "Some description."
    }
  }

  let(:invalid_attributes){
    {
      name: "",
      description: "Some description."
    }
  }

  describe "creation" do
    it "is valid with valid name" do
      status_object = Status.create(name: "some name")
      expect(status_object.name).to eq("some name")
      expect(status_object).to be_valid
    end

    it "is invalid without name" do
      status_object = Status.create(invalid_attributes)
      expect(status_object.errors.messages[:name]).to eq(["can't be blank"])
      expect(status_object).to be_invalid
    end
  end

end
