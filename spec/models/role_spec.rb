require 'rails_helper'

RSpec.describe Role, type: :model do

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
    it "is valid with name" do
      role_object = Role.create(name: "some name")
      expect(role_object.name).to eq("some name")
      expect(role_object).to be_valid
    end

    it "is invalid without name" do
      role_object = Role.create(invalid_attributes)
      expect(role_object.errors.messages[:name]).to eq(["can't be blank"])
      expect(role_object).to be_invalid
    end
  end

end
