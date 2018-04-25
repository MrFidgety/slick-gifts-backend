# frozen_string_literal: true

class Array
  # Shorthand for mapping an array of hashes to the specified key in the hash
  def map_to(*attributes)
    attributes.inject(self) do |memo, element|
      memo.map { |e| e[element] }
    end
  end
end
