require "rails_helper"

RSpec.describe WishlistsController do
  let(:valid_parameters) { { name: "Foo", description: "Foo" } }
  let(:invalid_parameters) { { name: "", description: "" } }

  describe "GET #new" do
    before do
      request_get
    end

    it "returns 200 HTTP status code" do
      expect(response).to have_http_status(200)
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
      before do
        request_post(valid_parameters)
      end

      it "creates a new Wishlist" do
        expect do
          post :create, params: { wishlist: valid_parameters }
        end.to change(Wishlist, :count).by(1)
      end

      it "assigns a newly created wishlist as @wishlist" do
        expect(assigns(:wishlist)).to be_a(Wishlist)
      end

      it "checks if assigned wishlist as @wishlist is persisted" do
        expect(assigns(:wishlist)).to be_persisted
      end

      it "redirects to the form page" do
        expect(response).to redirect_to(new_wishlist_path)
      end
    end

    context "with invalid parameters" do
      before do
        request_post(invalid_parameters)
      end

      it "returns 200 HTTP status code" do
        expect(response).to have_http_status(200)
      end

      it "assigns a newly created but unsaved wishlist as @wishlist" do
        expect(assigns(:wishlist)).to be_a_new(Wishlist)
      end

      it "doesn't create new wishlist" do
        expect do
          post :create, params: { wishlist: invalid_parameters }
        end.to_not change(Wishlist, :count)
      end

      it "re-renders the 'new' template" do
        expect(response).to render_template(:new)
      end
    end
  end

  private

  def request_get
    get :new
  end

  def request_post(parameters)
    post :create, params: { wishlist: parameters }
  end
end
