require 'spec_helper'

feature "user signs in" do
  scenario "with existing username" do
    wilson = Fabricate(:user)
    sign_in(wilson)
    page.should have_content wilson.full_name
  end

  scenario "with inactive account" do
    wilson = Fabricate(:user, active: false)
    sign_in(wilson)
    expect(page).not_to have_content(wilson.full_name)
    expect(page).to have_content("Your account has been suspended, please contact support.")
  end
end
