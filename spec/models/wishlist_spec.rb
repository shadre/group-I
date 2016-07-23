require "rails_helper"

RSpec.describe Wishlist do
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :items }

  it "creates a token for every new wishlist created" do
    expect(create(:wishlist)).to have_attributes(token: String)
  end
end
