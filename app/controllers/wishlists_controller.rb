class WishlistsController < ApplicationController
  def new
    @wishlist = Wishlist.new
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)
    if @wishlist.save
      redirect_to new_wishlist_path, notice: t(".success")
    else
      render :new
    end
  end

  private

  def wishlist_params
    params.require(:wishlist).permit(:name, :description, :user_id)
  end
end
