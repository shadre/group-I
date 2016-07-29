require "rails_helper"

RSpec.describe ReservationsController do
  let(:wishlist) { create(:wishlist, user: controller.current_user) }
  let(:item) { create(:item, wishlist: wishlist) }
  let(:reservation) { create(:reservation, item: item) }

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

  describe "DELETE #destroy" do
    context "when user is logged in" do
      before do
        sign_in_user
        delete_destroy(wishlist.id, item.id, reservation.id)
      end

      it "cancels gift reservation" do
        expect { Reservation.find(reservation.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "redirects to the wishlist page" do
        expect(response).to redirect_to(wishlist_path(wishlist.id))
      end

      it "shows a notice" do
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when user is not logged in" do
      before { delete_destroy(wishlist.id, item.id, reservation.id) }

      it "doesn't cancel gift reservation" do
        expect { reservation }.not_to change(Reservation, :count)
      end

      it "shows an alert" do
        expect(flash[:alert]).not_to be_nil
      end
    end
  end

  private

  def delete_destroy(wishlist_id, item_id, reservation_id)
    delete :destroy, params: { wishlist_id: wishlist_id, item_id: item_id, id: reservation_id }
  end

  def post_create(wishlist_id, item_id)
    post :create, params: { wishlist_id: wishlist_id, item_id: item_id }
  end
end
