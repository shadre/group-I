require "rails_helper"

RSpec.describe WishlistsController do
  context "when user is logged in" do
    before { sign_in_user }
    let(:wishlist) { create(:wishlist, user: controller.current_user) }

    describe "GET #index" do
      before { get :index }

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the 'index' template" do
        expect(response).to render_template(:index)
      end
    end

    describe "GET #new" do
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

    describe "POST #create" do
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

        it "redirects to the wishlists index page" do
          expect(response).to redirect_to(wishlists_path)
        end
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

    describe "DELETE #destroy" do
      context "when wishlist exists" do
        before { delete_destroy(id: wishlist.id) }

        it "deletes the wishlist" do
          expect { Wishlist.find(wishlist.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "redirects to the wishlists index page" do
          expect(response).to redirect_to(wishlists_url)
        end

        it "shows a notice" do
          expect(flash[:notice]).not_to be_nil
        end
      end

      context "when wishlist doesn't exist" do
        before { delete_destroy(id: -1) }

        it "redirects to the wishlists index page" do
          expect(response).to redirect_to(wishlists_path)
        end
      end
    end

    describe "GET #edit" do
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

        it "redirects to the wishlists index page" do
          expect(response).to redirect_to(wishlists_path)
        end

        it "shows an error" do
          expect(flash[:alert]).not_to be_nil
        end
      end
    end

    describe "PUT #update" do
      let(:new_params) { { name: "name" } }

      context "when params valid" do
        subject! { put_update(wishlist.id, new_params) }

        it "changes wishlist attributes" do
          expect(Wishlist.find(wishlist.id).name).to eq(new_params[:name])
        end

        it "doesn't change number of wishlists" do
          expect { subject }.not_to change(Wishlist, :count)
        end

        it "redirects to the wishlists index page" do
          expect(response).to redirect_to(wishlists_url)
        end

        it "shows a notice" do
          expect(flash[:notice]).not_to be_nil
        end
      end

      context "when params invalid" do
        before { put_update(wishlist.id, name: nil) }

        it "re-renders 'edit' form" do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  context "when not logged in" do
    let(:wishlist_id) { create(:wishlist).id }

    shared_examples "redirects to the 'sign_in' page" do
      it "redirects to the 'sign_in' page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #index" do
      before { get :index }

      include_examples "redirects to the 'sign_in' page"
    end

    describe "GET #new" do
      before { get :new }

      include_examples "redirects to the 'sign_in' page"
    end

    describe "POST #create" do
      context "with valid parameters" do
        before { post_create }

        include_examples "redirects to the 'sign_in' page"
      end

      context "with invalid parameters" do
        before { post_create(name: nil) }

        include_examples "redirects to the 'sign_in' page"
      end
    end

    describe "GET #edit" do
      context "with valid parameters" do
        before { get_edit(id: wishlist_id) }

        include_examples "redirects to the 'sign_in' page"
      end

      context "with invalid parameters" do
        before { get_edit(id: -1) }

        include_examples "redirects to the 'sign_in' page"
      end
    end

    describe "PUT #update" do
      context "with valid parameters" do
        before { put_update(wishlist_id, name: "blablablabla") }

        include_examples "redirects to the 'sign_in' page"
      end

      context "with invalid parameters" do
        before { put_update(wishlist_id, name: nil) }

        include_examples "redirects to the 'sign_in' page"
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
end
