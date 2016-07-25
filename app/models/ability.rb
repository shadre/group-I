class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can %i(create read destroy update), Wishlist, user_id: user.id
    end
  end
end
