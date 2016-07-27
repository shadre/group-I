require "rails_helper"

RSpec.describe ItemsController do
  let(:wishlist) { create(:wishlist, user: controller.current_user) }
  let(:item) { create(:item, wishlist: wishlist) }

  shared_examples "redirects to" do |path|
    it "redirects to the #{path}" do
      expect(response).to redirect_to(send(path))
    end
  end

  shared_examples "shows a flash message" do |flash_type|
    it "shows a/an #{flash_type}" do
      expect(flash[flash_type.to_s]).not_to be_nil
    end
  end

  describe "GET #new" do
    context "when user is logged in" do
      before { sign_in_user }

      context "when wishlist exists" do
        before { get_new(wishlist_id: wishlist.id) }

        it "returns 200 OK" do
          expect(response).to have_http_status(:ok)
        end

        it "renders the 'new' template" do
          expect(response).to render_template(:new)
        end
      end

      context "when wishlist doesn't exist" do
        before { get_new(wishlist_id: -1) }

        include_examples "redirects to", :wishlists_path
        include_examples "shows a flash message", :alert
      end
    end

    context "when not logged in" do
      context "with valid parameters" do
        before { get_new(wishlist_id: wishlist.id) }

        include_examples "redirects to", :new_user_session_path
      end

      context "with invalid parameters" do
        before { get_new(wishlist_id: -1) }

        include_examples "redirects to", :new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context "when user is logged in" do
      before { sign_in_user }

      context "with valid parameters" do
        before { post_create(name: "name", wishlist_id: wishlist.id) }

        it "assigns an instance variable under @item" do
          expect(assigns(:item)).to be_a(Item)
        end

        it "persists the new item" do
          expect(assigns(:item)).to be_persisted
          expect { post_create(name: "name", wishlist_id: wishlist.id) }.to change(Item, :count).by(1)
        end

        include_examples "redirects to", :wishlist
        include_examples "shows a flash message", :notice
      end

      context "with invalid parameters" do
        subject! { post_create(name: nil, wishlist_id: wishlist.id) }

        it "doesn't change number of items" do
          expect { subject }.to_not change(Item, :count)
        end

        it "re-renders the 'new' template" do
          expect(response).to render_template(:new)
        end

        include_examples "shows a flash message", :error
      end
    end

    context "when user is not logged in" do
      context "with valid parameters" do
        before { post_create(name: "name", wishlist_id: wishlist.id) }

        include_examples "redirects to", :new_user_session_path
      end

      context "with invalid parameters" do
        before { post_create(name: nil, wishlist_id: wishlist.id) }

        include_examples "redirects to", :new_user_session_path
      end
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

          include_examples "redirects to", :wishlist
          include_examples "shows a flash message", :alert
        end
      end

      context "when wishlist doesn't exist" do
        before { get_edit(item_id: item.id, wishlist_id: -1) }

        include_examples "redirects to", :wishlists_path
        include_examples "shows a flash message", :alert
      end
    end

    context "when user is not logged in" do
      let(:wishlist) { create(:wishlist) }
      let(:item) { create(:item) }

      context "with valid parameters" do
        before { get_edit(item_id: item.id, wishlist_id: wishlist.id) }

        include_examples "redirects to", :new_user_session_path
      end

      context "with invalid parameters" do
        before { get_edit(item_id: -1, wishlist_id: wishlist.id) }

        include_examples "redirects to", :new_user_session_path
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

        include_examples "redirects to", :wishlist
        include_examples "shows a flash message", :notice
      end

      context "when params invalid" do
        before { put_update(item.id, wishlist.id, name: nil) }

        it "re-renders 'edit' form" do
          expect(response).to render_template(:edit)
        end

        include_examples "shows a flash message", :error
      end
    end

    context "when user is not logged in" do
      context "with valid parameters" do
        before { put_update(item.id, wishlist.id, name: "blablablabla") }

        include_examples "redirects to", :new_user_session_path
      end

      context "with invalid parameters" do
        before { put_update(item.id, wishlist.id, name: nil) }

        include_examples "redirects to", :new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      before { sign_in_user }

      context "when item exists" do
        before { delete_destroy(item_id: item.id, wishlist_id: wishlist.id) }

        it "deletes the item" do
          expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        include_examples "redirects to", :wishlist
        include_examples "shows a flash message", :notice
      end

      context "when item doesn't exist" do
        before { delete_destroy(item_id: -1, wishlist_id: wishlist.id) }

        include_examples "redirects to", :wishlist
        include_examples "shows a flash message", :alert
      end

      context "when wishlist doesn't exist" do
        before { delete_destroy(item_id: item.id, wishlist_id: -1) }

        include_examples "redirects to", :wishlists_path
        include_examples "shows a flash message", :alert
      end
    end
  end

  private

  def get_new(wishlist_id:)
    get :new, params: { wishlist_id: wishlist_id }
  end

  def post_create(custom = {})
    post :create, params: { item: attributes_for(:item, custom), wishlist_id: custom[:wishlist_id] }
  end

  def get_edit(item_id:, wishlist_id:)
    get :edit, params: { id: item_id, wishlist_id: wishlist_id }
  end

  def put_update(item_id, wishlist_id, item_params)
    put :update,
      params: { id: item_id, wishlist_id: wishlist_id, item: attributes_for(:item, item_params) }
  end

  def delete_destroy(item_id:, wishlist_id:)
    delete :destroy, params: { id: item_id, wishlist_id: wishlist_id }
  end
end
