require "rails_helper"

RSpec.describe ReservationsController do
  let(:wishlist) { create(:wishlist) }
  let(:item) { create(:item) }

  describe "POST #create" do
    before { post_create(wishlist.id, item.id) }

    it "assigns id of the item in item_id field" do
      expect(item.reservation.item_id).to eq(item.id)
    end

    it "persists the new reservation" do
      expect(assigns(:reservation)).to be_persisted
      expect { post_create(wishlist.id, item.id) }.to change(Reservation, :count).by(1)
    end

    it "assigns an instance variable under @reservation" do
      expect(assigns(:reservation)).to be_a(Reservation)
    end

    it "returns a redirect" do
      expect(response).to be_redirect
    end

    it "redirects to the wishlist page for guest" do
      expect(response).to redirect_to(wishlists_for_guest_path(wishlist.token))
    end
  end

  private

  def post_create(wishlist_id, item_id)
    post :create, params: { wishlist_id: wishlist_id, item_id: item_id }
  end
end
