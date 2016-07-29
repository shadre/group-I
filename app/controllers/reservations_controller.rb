class ReservationsController < ApplicationController
  before_action :authenticate_user!, except: :create

  def create
    @reservation = Reservation.new(item_id: params[:item_id])
    return unless @reservation.save
    redirect_to wishlists_for_guest_path(Wishlist.find(params[:wishlist_id]).token), notice: t(".success")
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    authorize! :destroy, @reservation
    @reservation.destroy!
    redirect_to wishlist_path(params[:wishlist_id]), notice: t(".success")
  rescue CanCan::AccessDenied, ActiveRecord::RecordNotDestroyed
    redirect_to wishlist_path(params[:wishlist_id]), alert: t("generic_error")
  end
end
