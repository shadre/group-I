require "rails_helper"

RSpec.describe WishlistsController do
  context "when user is logged in" do
    before(:each) { sign_in_user }

    describe "GET #index" do
      before(:each) { get :index }

      it "returns 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the 'index' template" do
        expect(response).to render_template(:index)
      end
    end

    describe "GET #new" do
      before(:each) { get :new }

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
        before(:each) { post_create }

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
        before(:each) { post_create(name: nil) }

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
        let!(:wishlist) { create(:wishlist, user: controller.current_user) }
        subject! { delete_destroy(id: wishlist.id) }

        it "deletes the wishlist" do
          expect { Wishlist.find(wishlist.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "redirects to the wishlists index page" do
          is_expected.to redirect_to(wishlists_url)
        end

        it "shows a notice" do
          expect(flash[:notice]).not_to be_nil
        end
      end

      context "when wishlist doesn't exist" do
        subject! { delete_destroy(id: -1) }

        it "redirects to the wishlists index page" do
          is_expected.to redirect_to(wishlists_path)
        end

        it "shows an error" do
          expect(flash[:alert]).not_to be_nil
        end
      end
    end
  end

  context "when not logged in" do
    shared_examples "redirects to the 'sign_in' page" do
      it "returns a 3xx redirect" do
        expect(response).to be_redirect
      end

      it "redirects to the 'sign_in' page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #index" do
      before(:each) { get :index }

      include_examples "redirects to the 'sign_in' page"
    end

    describe "GET #new" do
      before(:each) { get :new }

      include_examples "redirects to the 'sign_in' page"
    end

    describe "POST #create" do
      context "with valid parameters" do
        before(:each) { post_create }

        include_examples "redirects to the 'sign_in' page"
      end

      context "with invalid parameters" do
        before(:each) { post_create(name: nil) }

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
end
