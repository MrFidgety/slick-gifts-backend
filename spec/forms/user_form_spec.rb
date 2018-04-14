# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserForm do
  let(:form) { described_class.new(User.new) }

  let(:user_attributes) do
    attributes_for(:user, password: "password")
  end

  subject(:validate) { form.validate(user_attributes) }

  it "is valid" do
    expect(validate).to eq true
  end

  it "can save the user" do
    expect { validate && form.save }.to change(User, :count).by 1
  end

  it_behaves_like "reform validates string not blank", :email do
    let(:attributes) { user_attributes }
  end

  it_behaves_like "reform strips whitespace", :email do
    let(:attributes) { user_attributes }
  end

  describe "email" do
    it "validates presence" do
      user_attributes.delete(:email)

      expect(validate).to eq false
    end

    it "validates format" do
      user_attributes[:email] = "invalid"

      expect(validate).to eq false
    end

    it "validates uniquness" do
      create(:user, email: user_attributes[:email])

      expect(validate).to eq false
    end

    it "validates uniqueness case-insensitively" do
      create(:user, email: user_attributes[:email])

      user_attributes[:email] = user_attributes[:email].upcase

      expect(validate).to eq false
    end
  end

  describe "password" do
    it "validates presence" do
      user_attributes.delete(:password)

      expect(validate).to eq false
    end

    it "validates presence of characters" do
      user_attributes[:password] = " " * User.password_length.min

      expect(validate).to eq false
    end

    it "validates min length" do
      user_attributes[:password] = "a" * (User.password_length.min - 1)

      expect(validate).to eq false
    end

    it "validates max length" do
      user_attributes[:password] = "a" * (User.password_length.max + 1)

      expect(validate).to eq false
    end
  end
end
