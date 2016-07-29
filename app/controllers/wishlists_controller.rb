class WishlistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wishlist!, only: %i(destroy edit update)

  def index
    authorize! :index, Wishlist
    @wishlists = Wishlist.created_by(current_user)
  end

  def new
    @wishlist = Wishlist.new(wishlist_params)
    authorize! :new, @wishlist
  rescue CanCan::AccessDenied
    redirect_to wishlists_path, alert: t("generic_error")
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)
    authorize! :create, @wishlist
    @wishlist.save!
    redirect_to wishlists_path, notice: t(".success")
  rescue CanCan::AccessDenied
    redirect_to wishlists_path, alert: t("generic_error")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".failure")
    render :new
  end

  def show
    @wishlist = Wishlist.find(params[:id])
    authorize! :show, @wishlist
  rescue ActiveRecord::RecordNotFound, CanCan::AccessDenied
    redirect_to wishlists_path, alert: t("generic_error")
  end

  def destroy
    authorize! :destroy, @wishlist
    @wishlist.destroy!
    redirect_to wishlists_path, notice: t(".success")
  rescue CanCan::AccessDenied, ActiveRecord::RecordNotDestroyed
    redirect_to wishlists_path, alert: t("generic_error")
  end

  def edit
    authorize! :edit, @wishlist
  rescue CanCan::AccessDenied
    redirect_to wishlists_path, alert: t("generic_error")
  end

  def update
    authorize! :update, @wishlist
    @wishlist.update_attributes!(wishlist_params)
    redirect_to @wishlist, notice: t(".success")
  rescue CanCan::AccessDenied
    redirect_to wishlists_path, alert: t("generic_error")
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  private

  def wishlist_params
    params[:wishlist] ||= {}
    params[:wishlist][:user_id] = current_user.id
    params.require(:wishlist).permit(:user_id, :name, :description)
  end

  def set_wishlist!
    @wishlist = Wishlist.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to wishlists_path, alert: t("generic_error")
  end
end
