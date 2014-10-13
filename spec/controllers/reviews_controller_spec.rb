require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "user is authenticated" do
      context "with valid inputs" do
        it "redirects to the video show page" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to video
        end
        #it "creates a review" do
        #  video = Fabricate(:video)
        #  post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        #  expect(Review.count).to eq(1)
        #end
          
        it "creates a review associated with the video"
        it "creates a review associated with the signed in user"
        
      end
    end

    context "user is not authenticated" do
      it "should redirect to the home page"
    end
  end
end
