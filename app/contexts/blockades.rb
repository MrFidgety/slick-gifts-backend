# frozen_string_literal: true

module Blockades
  class << self
    def create_blockade(*args)
      Blockades::CreateBlockade.perform(*args)
    end

    def destroy_blockade(*args)
      Blockades::DestroyBlockade.perform(*args)
    end
  end
end
