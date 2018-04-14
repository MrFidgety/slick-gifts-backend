# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  def described_class_factory
    described_class.name.underscore.to_sym
  end

  def build_with_id(factory, options = {})
    build(factory, options.merge(id: SecureRandom.uuid))
  end

  def build_list_with_id(factory, count, options = {})
    Array.new(count) { build_with_id(factory, options) }
  end

  def form
    Object.const_get("#{described_class.name}Form").new(described_class.new)
  end
end

shared_examples "has a valid factory" do
  specify do
    expect(form.validate(attributes_for(described_class_factory))).to eq true
  end
end
