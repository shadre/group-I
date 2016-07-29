class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wishlist, only: %i(new create edit update destroy)
  before_action :set_item, only: %i(edit update destroy)

  def new
    @item = @wishlist.items.new
    authorize! :new, @item
  end

  def create
    @item = @wishlist.items.new(item_params)
    authorize! :create, @item
    @item.save!
    redirect_to @wishlist, notice: t(".success")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".failure")
    render :new
  end

  def edit
    authorize! :edit, @item
  end

  def update
    authorize! :update, @item
    @item.update_attributes!(item_params)
    redirect_to @wishlist, notice: t(".success")
  rescue ActiveRecord::RecordInvalid
    flash[:error] = t(".failure")
    render :edit
  end

  def destroy
    authorize! :destroy, @item
    @item.destroy!
    redirect_to @wishlist, notice: t(".success")
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to wishlist, error: t("generic_error")
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
