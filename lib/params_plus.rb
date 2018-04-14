# frozen_string_literal: true

require "hash_plus"

class ParamsPlus
  def initialize(params, belongs_to: [], has_many: [])
    @params = params
    @belongs_to = belongs_to
    @has_many = has_many
  end

  def form_attributes
    block_given? ? yield(processed_attributes) : processed_attributes
  end

  private

    attr_reader :params
    attr_reader :belongs_to
    attr_reader :has_many

    def processed_attributes
      @processed_attributes ||= ::HashPlus.new(
        add_relationships(parsed_attributes)
          .transform_keys { |k| k.to_s.underscore.to_sym }
      )
    end

    def parsed_attributes
      parse_data(params)
    end

    def add_relationships(attrs)
      add_has_manys(add_belongs_tos(attrs))
    end

    def add_belongs_tos(attrs)
      belongs_to.reduce(attrs) do |acc, relationship|
        add_belong_to(acc, relationship)
      end
    end

    def add_has_manys(attrs)
      has_many.reduce(attrs) do |acc, relationship|
        add_has_many(acc, relationship)
      end
    end

    def add_belong_to(attrs, relationship)
      return attrs unless attrs.key? one_relationship_key(relationship)

      add_nested_resource(attrs, relationship)
    end

    def add_has_many(attrs, relationship)
      return attrs unless attrs.key? many_relationship_key(relationship)

      add_nested_resources(attrs, relationship)
    end

    def add_nested_resource(attrs, relationship)
      attrs.merge(relationship => nested_data(attrs, relationship))
           .except(one_relationship_key(relationship))
    end

    def add_nested_resources(attrs, relationship)
      attrs.merge(relationship.to_sym => nesting_for(attrs, relationship))
           .except(many_relationship_key(relationship))
    end

    def nested_data(_attrs, relationship)
      rel_params = relationship_params(relationship)
      return { id: nil } if unsetting_relationship?(rel_params)

      parse_data(rel_params)
    end

    def nesting_for(_attrs, relationship)
      params["data"]["relationships"][relationship]["data"].map do |data|
        parse_data("data" => data.to_unsafe_hash)
      end
    end

    # Too much parsing going on here? Maybe delegate?
    def parse_data(data)
      ActiveModelSerializers::Deserialization.jsonapi_parse!(data)
    end

    def one_relationship_key(relationship)
      "#{relationship.underscore}_id".to_sym
    end

    def many_relationship_key(relationship)
      "#{relationship.underscore.singularize}_ids".to_sym
    end

    def relationship_params(relationship)
      params["data"]["relationships"][relationship]
    end

    def unsetting_relationship?(params)
      params.present? && params.key?("data") && params["data"].blank?
    end

    class << self
      def param_true?(value)
        (value.to_s != "false") && (value.to_s != "0") && (value.to_s != "")
      end
    end
end
