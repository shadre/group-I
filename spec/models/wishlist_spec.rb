require "rails_helper"

RSpec.describe Wishlist do
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :items }

  describe "validations" do
    it "requires a name" do
      expect(build(:wishlist, name: nil)).to be_invalid
    end

    it "has an optional description" do
      expect(build(:wishlist, description: nil)).to be_valid
    end

    it "sets token on its own if none provided" do
      expect(build(:wishlist)).not_to be_nil
    end

    it "accepts a token passed in initialization" do
      expect(build(:wishlist, token: "unique-token")).to be_valid
    end

    it "requires a token to be unique" do
      existing_wishlist = create(:wishlist)
      expect(build(:wishlist, token: existing_wishlist.token)).to be_invalid
    end
  end
end
