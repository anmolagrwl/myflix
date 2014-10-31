require 'spec_helper'

feature "user signs in" do
  scenario "with existing username" do
    wilson = Fabricate(:user)
    sign_in(wilson)
    page.should have_content wilson.full_name
  end
end
