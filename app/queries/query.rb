# frozen_string_literal: true

class Query
  DEFAULT_PAGE_SIZE = 25
  DEFAULT_MIN_PAGE_SIZE = 1
  DEFAULT_MAX_PAGE_SIZE = 100

  attr_reader :included_resources
  attr_reader :page

  class << self
    def all(*args)
      new(*args).all
    end

    def find(id, *args)
      new(*args).all.find id
    end
  end

  def all
    raise NotImplementedError
  end

  def page_number
    page.fetch(:number, 1)
  end

  def page_size
    restrict_page_size(page.fetch(:size, DEFAULT_PAGE_SIZE))
  end

  def restrict_page_size(size)
    size.clamp(minimum_page_size, maximum_page_size)
  end

  def minimum_page_size
    ENV.fetch('MIN_PAGE_SIZE', DEFAULT_MIN_PAGE_SIZE).to_i
  end

  def maximum_page_size
    ENV.fetch('MAX_PAGE_SIZE', DEFAULT_MAX_PAGE_SIZE).to_i
  end

  private

  def sanitized_included_resources
    sanitize_nested(eager_load_resources)
  end

  def included_attachments
    included_resources & top_level_attachment_resources
  end

  def sanitize_nested(includes)
    includes.each_with_object({}) do |item, memo|
      key, value = item.split('.')

      memo[key] = ((memo[key] || []) << parse_include(key, value)).compact
    end
  end

  def eager_load_resources
    included_resources - included_attachments
  end

  def parse_include(key, value)
    translated_includes.dig(key, value) || value
  end

  def top_level_attachment_resources
    []
  end

  def translated_includes
    {}
  end
end
