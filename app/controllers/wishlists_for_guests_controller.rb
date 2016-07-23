class WishlistsForGuestsController < ApplicationController
  def show
    @wishlist = Wishlist.find_by(token: params[:token])
    render file: "public/404" unless @wishlist
  end
end
