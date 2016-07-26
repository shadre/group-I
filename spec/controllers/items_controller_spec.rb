require "rails_helper"

RSpec.describe ItemsController do
  let(:wishlist) { create(:wishlist, user: controller.current_user) }
  let(:item) { create(:item, wishlist: wishlist) }

  shared_examples "redirects to the 'sign_in' page" do
    it "redirects to the 'sign_in' page" do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET #edit" do
    context "when user is logged in" do
      before { sign_in_user }

      context "when wishlist exists" do
        context "when item exists" do
          before { get_edit(item_id: item.id, wishlist_id: wishlist.id) }

          it "returns 200 OK" do
            expect(response).to have_http_status(:ok)
          end

          it "renders the 'edit' template" do
            expect(response).to render_template(:edit)
          end
        end

        context "when item doesn't exist" do
          before { get_edit(item_id: -1, wishlist_id: wishlist.id) }

          it "redirects to the root page" do
            expect(response).to redirect_to(root_url)
          end

          it "shows an error" do
            expect(flash[:alert]).not_to be_nil
          end
        end
      end

      context "when wishlist doesn't exist" do
        before { get_edit(item_id: item.id, wishlist_id: -1) }

        it "redirects to the root page" do
          expect(response).to redirect_to(root_url)
        end

        it "shows an error" do
          expect(flash[:alert]).not_to be_nil
        end
      end
    end

    context "when user is not logged in" do
      let(:wishlist) { create(:wishlist) }
      let(:item) { create(:item) }

      context "with valid parameters" do
        before { get_edit(item_id: item.id, wishlist_id: wishlist.id) }

        include_examples "redirects to the 'sign_in' page"
      end

      context "with invalid parameters" do
        before { get_edit(item_id: -1, wishlist_id: wishlist.id) }

        include_examples "redirects to the 'sign_in' page"
      end
    end
  end

  describe "PUT #update" do
    context "when user is logged in" do
      before { sign_in_user }

      context "when params valid" do
        let(:new_params) { { name: "name" } }
        subject! { put_update(item.id, wishlist.id, new_params) }

        it "changes item attributes" do
          expect(Item.find(item.id).name).to eq(new_params[:name])
        end

        it "doesn't change number of items" do
          expect { subject }.not_to change(Item, :count)
        end

        it "redirects to the wishlist page" do
          expect(response).to redirect_to(wishlist)
        end

        it "shows a notice" do
          expect(flash[:notice]).not_to be_nil
        end
      end

      context "when params invalid" do
        before { put_update(item.id, wishlist.id, name: nil) }

        it "re-renders 'edit' form" do
          expect(response).to render_template(:edit)
        end

        it "shows an error" do
          expect(flash[:error]).not_to be_nil
        end
      end
    end

    context "when user is not logged in" do
      context "with valid parameters" do
        before { put_update(item.id, wishlist.id, name: "blablablabla") }

        include_examples "redirects to the 'sign_in' page"
      end

      context "with invalid parameters" do
        before { put_update(item.id, wishlist.id, name: nil) }

        include_examples "redirects to the 'sign_in' page"
      end
    end
  end

  private

  def get_edit(item_id:, wishlist_id:)
    get :edit, params: { id: item_id, wishlist_id: wishlist_id }
  end

  def put_update(item_id, wishlist_id, item_params)
    put :update,
      params: { id: item_id, wishlist_id: wishlist_id, item: attributes_for(:item, item_params) }
  end
end
