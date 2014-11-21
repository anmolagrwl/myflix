require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    monk = Fabricate(:video, title: "Monk") do
      categories(count: 1) { Fabricate(:category) }
    end
    south_park = Fabricate(:video, title: "South Park") do
      categories(count: 1) { Fabricate(:category) }
    end
    futurama = Fabricate(:video, title: "Futurama") do
      categories(count: 1) { Fabricate(:category) }
    end
    
    sign_in

    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    visit video_path(monk)
    expect_button_to_be_absent("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    set_video_position(monk, 3)
    set_video_position(south_park, 2)
    set_video_position(futurama, 1)

    update_queue

    expect_video_position(monk, 3)
    expect_video_position(south_park, 2)
    expect_video_position(futurama, 1)
  end
  
  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end

  def add_video_to_queue(video)
    visit home_path
    click_on_video_on_home_page(video)
    click_button "+ My Queue"
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content(video.title)
  end

  def expect_button_to_be_absent(text)
    page.should_not have_button text
  end

  def update_queue
    click_button "Update Instant Queue"
  end
end
