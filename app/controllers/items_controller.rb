class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wishlist_and_item, only: %i(edit update)

  def edit
    authorize! :edit, @item
  rescue CanCan::AccessDenied
    redirect_to root_url, alert: t("generic_error")
  end

  def update
    authorize! :update, @item
    @item.update_attributes!(item_params)
    redirect_to @wishlist, notice: t(".success")
  rescue CanCan::AccessDenied
    redirect_to root_url, alert: t("generic_error")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".failure")
    render :edit
  end

  private

  def item_params
    params.require(:item).permit(:name, :description)
  end

  def set_wishlist_and_item
    @wishlist = Wishlist.find(params[:wishlist_id])
    @item = @wishlist.items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, alert: t("generic_error")
  end
end
