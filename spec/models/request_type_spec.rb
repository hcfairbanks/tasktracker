require 'rails_helper'

RSpec.describe RequestType, type: :model do
  let(:user_role){FactorBot.build(:role,{name:'user'})}
  let(:user_bob){FactoryBot.build(:user,role_id:user_role.id)}

  let(:valid_attributes){
    {
      name: "Some name."
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
      request_type_object = RequestType.create(valid_attributes)
      expect(request_type_object.name).to eq("Some name.")
      expect(request_type_object).to be_valid
    end

    it "is invalid without name" do
      request_type_object = RequestType.create(invalid_attributes)
      expect(request_type_object.errors.messages[:name]).to eq(["can't be blank"])
      expect(request_type_object).to be_invalid
    end
  end

end
