shared_examples "require_sign_in" do
  it "redirects the user to the sign in path" do
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "tokenable" do
  it "generates a random token when the user is created" do
    expect(object.token).to be_present
  end
end

shared_examples "requires admin" do
  it "redirects regular user to home path" do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end