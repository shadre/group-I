class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:create, :read, :destroy], Wishlist, user_id: user.id
    end
  end
end
