require 'spec_helper'

feature "admin creates video" do
  scenario "as a valid admin", :vcr do
    wilson = Fabricate(:user, admin: true)
    sign_in(wilson)
    visit (new_admin_video_path)
    expect(page).to have_content("Add a New Video")

    fill_in('Title', with: "Title")
    fill_in('Description', with: "Description")
    attach_file('Large cover', 'spec/support/uploads/large_cover.jpg')
    attach_file('Small cover', 'spec/support/uploads/small_cover.jpg')
    fill_in('Video S3 URL', with: 'https://s3.amazonaws.com/coreycodes-myflix-development/uploads/fish3.mp4')
    click_button('Add Video')
    expect(page).to have_content("Video Title added.")
    sign_out

    sign_in
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='https://coreycodes-myflix-development.s3.amazonaws.com/uploads/large_cover.jpg']")
    expect(page).to have_selector("a[href='https://s3.amazonaws.com/coreycodes-myflix-development/uploads/fish3.mp4']")
  end
end
