# frozen_string_literal: true

class UsersQuery < Query
  def initialize(query_string, page: {}, includes: [])
    @query_string = query_string
    @page = page
    @included_resources = includes
  end

  def all
    User.search_by_names(query_string)
        .includes(included_resources)
        .page(page_number)
        .per(page_size)
  end

  private

  attr_reader :query_string
end
