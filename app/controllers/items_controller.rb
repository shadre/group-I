class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wishlist, only: %i(new create edit update)
  before_action :set_item, only: %i(edit update)

  def new
    @item = @wishlist.items.new
    authorize! :new, @item
  rescue CanCan::AccessDenied
    redirect_to @wishlist, alert: t("generic_error")
  end

  def create
    @item = @wishlist.items.new(item_params)
    authorize! :create, @item
    @item.save!
    redirect_to @wishlist, notice: t(".success")
  rescue CanCan::AccessDenied
    redirect_to @wishlist, alert: t("generic_error")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".failure")
    render :new
  end

  def edit
    authorize! :edit, @item
  rescue CanCan::AccessDenied
    redirect_to @wishlist, alert: t("generic_error")
  end

  def update
    authorize! :update, @item
    @item.update_attributes!(item_params)
    redirect_to @wishlist, notice: t(".success")
  rescue CanCan::AccessDenied
    redirect_to @wishlist, alert: t("generic_error")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".failure")
    render :edit
  end

  private

  def item_params
    params.require(:item).permit(:name, :description)
  end

  def set_wishlist
    @wishlist = Wishlist.find(params[:wishlist_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to wishlists_url, alert: t("generic_error")
  end

  def set_item
    @item = @wishlist.items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @wishlist, alert: t("generic_error")
  end
end
