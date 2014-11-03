shared_examples "require_sign_in" do
  it "redirects the user to the sign in path" do
    action
    expect(response).to redirect_to sign_in_path
  end
end
