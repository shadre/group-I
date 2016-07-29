require "cancan/matchers"
require "rails_helper"

RSpec.describe User do
  it { is_expected.to have_many :wishlists }

  it "is valid with valid params" do
    expect(build(:user)).to be_valid
  end

  it "has associated wishlists that should be destroyed" do
    wishlist = create(:wishlist)
    expect { wishlist.user.destroy }.to change { Wishlist.count }.by(-1)
  end

  context "is invalid" do
    context "with an email that's" do
      it "nil" do
        expect(build(:user, email: nil)).not_to be_valid
      end

      it "empty" do
        expect(build(:user, email: "")).not_to be_valid
      end

      it "blank" do
        expect(build(:user, email: "  ")).not_to be_valid
      end

      it "mangled" do
        expect(build(:user, email: "bob-example@")).not_to be_valid
      end

      it "non-unique" do
        user = create(:user)
        expect(build(:user, email: user.email)).not_to be_valid
      end
    end

    context "with a password that's" do
      it "nil" do
        expect(build(:user, password: nil)).not_to be_valid
      end

      it "empty" do
        expect(build(:user, password: "")).not_to be_valid
      end

      it "blank" do
        expect(build(:user, password: "  ")).not_to be_valid
      end

      it "shorter than 6 chars" do
        expect(build(:user, password: "12345")).not_to be_valid
      end

      it "longer than 128 chars" do
        expect(build(:user, password: "a" * 129)).not_to be_valid
      end
    end
  end

  describe "abilites" do
    let(:bob) { create(:bob) }
    let(:alice) { create(:alice) }
    let(:bob_wishlist_item) { create(:item, wishlist: bob.wishlists.first) }
    let(:alice_wishlist_item) { create(:item, wishlist: alice.wishlists.first) }
    let(:alice_reservation) { create(:reservation, item: alice_wishlist_item) }
    let(:bob_reservation) { create(:reservation, item: bob_wishlist_item) }

    subject(:ability) { Ability.new(bob) }

    it { is_expected.to be_able_to(:create, Wishlist) }
    it { is_expected.to be_able_to(:read, bob.wishlists.first) }
    it { is_expected.not_to be_able_to(:read, alice.wishlists.first) }
    it { is_expected.not_to be_able_to(:destroy, alice.wishlists.first) }
    it { is_expected.to be_able_to(:update, bob.wishlists.first) }
    it { is_expected.not_to be_able_to(:update, alice.wishlists.first) }
    it { is_expected.to be_able_to(:update, bob_wishlist_item) }
    it { is_expected.not_to be_able_to(:update, alice_wishlist_item) }
    it { is_expected.to be_able_to(:destroy, bob_wishlist_item) }
    it { is_expected.not_to be_able_to(:destroy, alice_wishlist_item) }
    it { is_expected.to be_able_to(:destroy, bob_reservation) }
    it { is_expected.not_to be_able_to(:destroy, alice_reservation) }
  end
end
