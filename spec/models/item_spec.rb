require "rails_helper"

RSpec.describe Item do
  it { is_expected.to belong_to :wishlist }

  describe "validations" do
    it "requires a name" do
      expect(build(:item, name: nil)).to be_invalid
    end

    it "has an optional description" do
      expect(build(:item, description: nil)).to be_valid
    end
  end

  describe "associations" do
    it "has wishlist_id" do
      item = create(:item)
      expect(item.wishlist_id).not_to be_nil
    end
  end
end
