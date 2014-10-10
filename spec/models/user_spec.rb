require 'spec_helper'



describe User do
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:full_name)}
  it { should validate_presence_of(:password)}

  describe "Validations" do
    
    it "should only require a password, but no password_confirmation" do
      user = User.create(password: "testing123", email: "test@test.com", full_name: "david lee")
      user.should be_valid
    end

    it "should not be valid without a password" do
      user = User.create(password: nil, email: "test@test.com", full_name: "david lee")
      user.should_not be_valid
    end

    it "should not be valid with an empty string password" do
      user = User.create(password: "", email: "test@test.com", full_name: "david lee")
      user.should_not be_valid
    end

    it "should not be valid with a password less than 6 characters" do
      user = User.create(password: "aaaaa", email: "test@test.com", full_name: "david lee")
      user.should_not be_valid
    end
  end
end
