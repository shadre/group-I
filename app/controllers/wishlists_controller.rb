class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :index, Wishlist
    @wishlists = Wishlist.created_by(current_user)
  end

  def new
    @wishlist = Wishlist.new(wishlist_params)
    authorize! :new, @wishlist
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)
    authorize! :create, @wishlist
    if @wishlist.save
      redirect_to wishlists_path, notice: t(".success")
    else
      render :new
    end
  end

  private

  def wishlist_params
    params[:wishlist] ||= {}
    params[:wishlist][:user_id] = current_user.id
    params.require(:wishlist).permit(:user_id, :name, :description)
  end
end
