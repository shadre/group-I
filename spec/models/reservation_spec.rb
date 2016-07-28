require "rails_helper"

RSpec.describe Reservation do
  it { is_expected.to belong_to :item }

  describe "associations" do
    it "has item_id" do
      reservation = create(:reservation)
      expect(reservation.item_id).not_to be_nil
    end
  end
end
