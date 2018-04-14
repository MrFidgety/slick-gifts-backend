# frozen_string_literal: true

class HashPlus
  extend Forwardable

  def_delegators :@hash, :[], :dig, :[]=, :delete, :transform_keys, :only,
                 :except

  def initialize(hash)
    @hash = hash
  end

  def transform(*args)
    self.class.new(args.reduce(@hash) do |acc, a_lambda|
      a_lambda.call acc
    end)
  end

  def transform_keys(*args)
    self.class.new(@hash.transform_keys(*args))
  end

  def to_hash
    @hash
  end

  def ==(other)
    @hash = other.instance_variable_get(:@hash)
  end
end
