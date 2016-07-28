class ReservationsController < ApplicationController
  def create
    @reservation = Reservation.new(item_id: params[:item_id])
    return unless @reservation.save
    redirect_to wishlists_for_guest_path(Wishlist.find(params[:wishlist_id]).token), notice: t(".success")
  end
end
