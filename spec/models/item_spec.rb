require "rails_helper"

RSpec.describe Item do
  it { is_expected.to belong_to :wishlist }
end
