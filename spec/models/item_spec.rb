require "rails_helper"

RSpec.describe Item do
  it { is_expected.to belong_to :wishlist }
  it { is_expected.to have_one :reservation }

  describe "validations" do
    it "requires a name" do
      expect(build(:item, name: nil)).to be_invalid
    end

    it "has an optional description" do
      expect(build(:item, description: nil)).to be_valid
    end
  end

  describe "#reserved?" do
    context "gift is not reserved" do
      it "returns false" do
        item = create(:item)
        expect(item.reserved?).to be(false)
      end
    end

    context "gift is reserved" do
      it "returns true " do
        reservation = create(:reservation)
        expect(reservation.item.reserved?).to be(true)
      end
    end
  end

  describe "associations" do
    it "has wishlist_id" do
      item = create(:item)
      expect(item.wishlist_id).not_to be_nil
    end

    it "has associated reservations that should be destroyed" do
      reservation = create(:reservation)
      expect { reservation.item.destroy }.to change { Reservation.count }.by(-1)
    end
  end
end
