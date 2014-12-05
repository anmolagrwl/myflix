require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    alice = Fabricate(:user)
    sign_in(alice)

    invite_friend
    friend_accepts_invitation

    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

    clear_email
  end

  def invite_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email", with: "john@doe.com"
    fill_in "Message", with: "Yo, sign up!"
    click_button "Send Invitation" 
  end

  def friend_accepts_invitation
    open_email "john@doe.com"
    current_email.click_link "Accept this invitation"
    fill_in "Password", with: "passwordsecure"
    fill_in "Full Name", with: "Johnny Doe"
    click_button "Sign Up"
  end

  def friend_should_follow(another_user)
    click_link "People"
    expect(page).to have_content another_user.full_name
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "Johnny Doe"
  end
end