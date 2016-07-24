class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:create, :read], Wishlist, user_id: user.id
    end
  end
end
