require 'spec_helper'

feature "User registers", :vcr, js: true do
  background do
    visit register_path
  end
  
  scenario "with valid info and valid card" do
    fill_in_valid_user_info    
    fill_in_valid_card_info
    click_button "Sign Up"

    expect(page).to have_content "You have successfully created an account and started your payment. Woohoo!"
  end
  
  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info    
    fill_in_invalid_card_info
    click_button "Sign Up"

    expect(page).to have_content "This card number looks invalid"
  end

  scenario "with invalid user info and valid card" do
    fill_in_invalid_user_info    
    fill_in_valid_card_info
    click_button "Sign Up"

    expect(page).to have_content "Please fix the errors below"
  end

  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info    
    fill_in_invalid_card_info
    click_button "Sign Up"

    expect(page).to have_content "This card number looks invalid"
    expect(page).to_not have_content "Please fix the errors below"
  end
  scenario "with invalid user info and declined card" do
    fill_in_valid_user_info    
    fill_in_declined_card_info
    click_button "Sign Up"

    expect(page).to have_content "Your card was declined."
  end
end

def fill_in_valid_user_info
  fill_in "Email Address", with: "ccondardo@gmail.com"
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "Corey Condardo"
end

def fill_in_invalid_user_info
  fill_in "Email Address", with: ""
  fill_in "Password", with: ""
  fill_in "Full Name", with: ""
end

def fill_in_valid_card_info
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "12 - December", from: "date_month"
  select "2018", from: "date_year"
end

def fill_in_invalid_card_info
  fill_in "Credit Card Number", with: "123"
  fill_in "Security Code", with: "123"
  select "12 - December", from: "date_month"
  select "2018", from: "date_year"
end

def fill_in_declined_card_info
  fill_in "Credit Card Number", with: "4000000000000002"
  fill_in "Security Code", with: "123"
  select "12 - December", from: "date_month"
  select "2018", from: "date_year"
end