require "rails_helper"

RSpec.describe User do
  let(:valid_user_params) { { email: "bob@example.org", password: "secret" } }

  it { is_expected.to have_many :wishlists }

  it "is valid with valid params" do
    expect(User.new(valid_user_params)).to be_valid
  end

  context "is invalid" do
    context "with an email that's" do
      it "nil" do
        expect(User.new(valid_user_params.merge!(email: nil))).not_to be_valid
      end

      it "empty" do
        expect(User.new(valid_user_params.merge!(email: ""))).not_to be_valid
      end

      it "blank" do
        expect(User.new(valid_user_params.merge!(email: "  "))).not_to be_valid
      end

      it "mangled" do
        expect(User.new(valid_user_params.merge!(email: "bob-example@"))).not_to be_valid
      end

      it "non-unique" do
        User.create(valid_user_params)
        expect(User.new(valid_user_params.merge!(email: valid_user_params[:email]))).not_to be_valid
      end
    end

    context "with a password that's" do
      it "nil" do
        expect(User.new(valid_user_params.merge!(password: nil))).not_to be_valid
      end

      it "empty" do
        expect(User.new(valid_user_params.merge!(password: ""))).not_to be_valid
      end

      it "blank" do
        expect(User.new(valid_user_params.merge!(password: "  "))).not_to be_valid
      end

      it "shorter than 6 chars" do
        expect(User.new(valid_user_params.merge!(password: "12345"))).not_to be_valid
      end

      it "longer than 128 chars" do
        expect(User.new(valid_user_params.merge!(password: "a" * 129))).not_to be_valid
      end
    end
  end
end
