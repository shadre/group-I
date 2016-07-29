class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can %i(create read destroy update), Wishlist, user_id: user.id
      can %i(create update destroy), Item, wishlist: { user_id: user.id }
      can %i(destroy), Reservation, item: { wishlist: { user_id: user.id } }
    end
  end
end
