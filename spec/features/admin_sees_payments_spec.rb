require 'spec_helper'

feature "Admin sees payments", js: true do
  background do
    alice = Fabricate(:user, full_name: "Alice Doe", email: "alice@aol.com")
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario "admin can see payments"  do
    admin = Fabricate(:user, admin: true)
    sign_in(admin)
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Doe")
    expect(page).to have_content("alice@aol.com")
  end

  scenario "user cannot see payments" do
    not_admin = Fabricate(:user)
    sign_in(not_admin)
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice Doe")
    expect(page).not_to have_content("alice@aol.com")
  end
end