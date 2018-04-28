# frozen_string_literal: true

shared_examples 'reform validates presence of' do |key|
  let(:attributes) { nil }

  specify do
    attributes.delete(key.to_sym)
    expect(validate).to eq(false), failure_message(key)
  end

  def failure_message(key)
    "Expected to validate presence of #{key}, but validated successfully"
  end
end

shared_examples 'reform validates string not blank' do |*keys|
  let(:attributes) { nil }

  keys.each do |key|
    specify do
      attributes[key.to_sym] = ' '
      expect(validate).to eq(false), failure_message(key)
    end

    def failure_message(key)
      "Expected to validate #{key} is not blank, but validated successfully"
    end
  end
end

shared_examples 'reform strips whitespace' do |*keys|
  let(:attributes) { nil }

  keys.each do |key|
    specify do
      attributes[key.to_sym] = " #{attributes[key.to_sym]} "

      validate

      expect(form.send(key.to_sym))
        .to eq(attributes[key.to_sym].strip), failure_message(key)
    end

    def failure_message(key)
      "Expected to strip whitespace from #{key}, " \
      'but whitespace was not stripped'
    end
  end
end
