require "rails_helper"

RSpec.describe WishlistsController do
  let(:wishlist) { create(:wishlist, user: controller.current_user) }

  shared_examples "redirects to" do |path_helper|
    it "redirects to the #{path_helper}" do
      expect(response).to redirect_to(send(path_helper))
    end
  end

  shared_examples "shows a flash message" do |flash_type|
    it "shows a/an #{flash_type}" do
      expect(flash[flash_type.to_s]).not_to be_nil
    end
  end

  describe "GET #index" do
    context "when user is logged in" do
      before { sign_in_user }
      before { get :index }

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the 'index' template" do
        expect(response).to render_template(:index)
      end
    end

    context "when not logged in" do
      before { get :index }

      include_examples "redirects to", :new_user_session_path
    end
  end

  describe "GET #new" do
    context "when user is logged in" do
      before { sign_in_user }
      before { get :new }

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the 'new' template" do
        expect(response).to render_template(:new)
      end

      it "assigns a new wishlist as @wishlist" do
        expect(assigns(:wishlist)).to be_a_new(Wishlist)
      end
    end

    context "when not logged in" do
      before { get :new }

      include_examples "redirects to", :new_user_session_path
    end
  end

  describe "POST #create" do
    context "when user is logged in" do
      before { sign_in_user }

      context "with valid parameters" do
        before { post_create }

        it "assigns an instance variable under @wishlist" do
          expect(assigns(:wishlist)).to be_a(Wishlist)
        end

        it "persists the new wishlist" do
          expect(assigns(:wishlist)).to be_persisted
          expect { post_create }.to change(Wishlist, :count).by(1)
        end

        it "returns a redirect" do
          expect(response).to be_redirect
        end

        include_examples "redirects to", :wishlists_path
      end

      context "with invalid parameters" do
        before { post_create(name: nil) }

        it "returns 200 OK" do
          expect(response).to have_http_status(:ok)
        end

        it "assigns an instance variable under @wishlist" do
          expect(assigns(:wishlist)).to be_a(Wishlist)
        end

        it "doesn't persist the wishlist" do
          expect(assigns(:wishlist)).not_to be_persisted
          expect { post_create(name: nil) }.to_not change(Wishlist, :count)
        end

        it "renders the 'new' template" do
          expect(response).to render_template(:new)
        end
      end
    end

    context "when not logged in" do
      context "with valid parameters" do
        before { post_create }

        include_examples "redirects to", :new_user_session_path
      end

      context "with invalid parameters" do
        before { post_create(name: nil) }

        include_examples "redirects to", :new_user_session_path
      end
    end
  end

  describe "GET #show" do
    context "when user is logged in" do
      before { sign_in_user }

      context "when wishlist is created by logged in user" do
        before do
          new_wishlist = create(:wishlist, user: controller.current_user)
          get_show(new_wishlist.id)
        end

        it "returns 200 HTTP status code" do
          expect(response).to have_http_status(200)
        end

        it "renders the 'show' template" do
          expect(response).to render_template(:show)
        end
      end

      context "when wishlist is not created by logged in user" do
        before do
          alice = create(:alice)
          alices_wishlist = create(:wishlist, user_id: alice.id)
          get_show(alices_wishlist.id)
        end

        include_examples "redirects to", :wishlists_path
      end
    end

    context "when not logged in" do
      let(:id) { 0 }
      before(:each) { get_show(id) }

      include_examples "redirects to", :new_user_session_path
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      before { sign_in_user }

      context "when wishlist exists" do
        before { delete_destroy(id: wishlist.id) }

        it "deletes the wishlist" do
          expect { Wishlist.find(wishlist.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        include_examples "redirects to", :wishlists_path
        include_examples "shows a flash message", :notice
      end

      context "when wishlist doesn't exist" do
        before { delete_destroy(id: -1) }

        include_examples "redirects to", :wishlists_path
      end
    end
  end

  describe "GET #edit" do
    context "when user is logged in" do
      before { sign_in_user }

      context "when wishlist exists" do
        before { get_edit(id: wishlist.id) }

        it "returns 200 OK" do
          expect(response).to have_http_status(:ok)
        end

        it "renders the 'edit' template" do
          expect(response).to render_template(:edit)
        end
      end

      context "when wishlist doesn't exist" do
        before { get_edit(id: -1) }

        include_examples "redirects to", :wishlists_path
        include_examples "shows a flash message", :alert
      end
    end

    context "when not logged in" do
      context "with valid parameters" do
        before { get_edit(id: wishlist.id) }

        include_examples "redirects to", :new_user_session_path
      end

      context "with invalid parameters" do
        before { get_edit(id: -1) }

        include_examples "redirects to", :new_user_session_path
      end
    end
  end

  describe "PUT #update" do
    context "when user is logged in" do
      let(:new_params) { { name: "name" } }

      before { sign_in_user }

      context "when params valid" do
        subject! { put_update(wishlist.id, new_params) }

        it "changes wishlist attributes" do
          expect(Wishlist.find(wishlist.id).name).to eq(new_params[:name])
        end

        it "doesn't change number of wishlists" do
          expect { subject }.not_to change(Wishlist, :count)
        end

        include_examples "redirects to", :wishlist
        include_examples "shows a flash message", :notice
      end

      context "when params invalid" do
        before { put_update(wishlist.id, name: nil) }

        it "re-renders 'edit' form" do
          expect(response).to render_template(:edit)
        end
      end
    end

    context "when not logged in" do
      context "with valid parameters" do
        before { put_update(wishlist.id, name: "blablablabla") }

        include_examples "redirects to", :new_user_session_path
      end

      context "with invalid parameters" do
        before { put_update(wishlist.id, name: nil) }

        include_examples "redirects to", :new_user_session_path
      end
    end
  end

  private

  def delete_destroy(id: nil)
    delete :destroy, params: { id: id }
  end

  def post_create(custom = {})
    post :create, params: { wishlist: attributes_for(:wishlist, custom) }
  end

  def get_edit(id:)
    get :edit, params: { id: id }
  end

  def put_update(id, wishlist_params)
    put :update, params: { id: id, wishlist: attributes_for(:wishlist, wishlist_params) }
  end

  def get_show(id)
    get :show, params: { id: id }
  end
end
