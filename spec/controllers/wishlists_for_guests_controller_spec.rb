require "rails_helper"

RSpec.describe WishlistsForGuestsController do
  let(:correct_token) { create(:wishlist).token }
  let(:incorrect_token) { "000" }

  describe "GET show" do
    context "when a valid token is provided" do
      before do
        get_show(correct_token)
      end

      it "has a 200 status code" do
        expect(response.status).to eq(200)
      end
    end

    context "when an invalid token is provided" do
      before do
        get_show(incorrect_token)
      end

      it "renders a 404 page" do
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end
  end

  private

  def get_show(token)
    get :show, params: { token: token }
  end
end
