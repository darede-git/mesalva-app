# frozen_string_literal: true

module DesignSystem
  class ComponentBase
    DEFAULT_SIZES = %i[sm md]
    DEFAULT_FIELDS = {
      controller: :string,
      endpoint: :string,
      class_name: :string,
    }
    FIELDS = { }

    def initialize(data = nil)
      @component = { component: self.class::COMPONENT_NAME }
      create_sections
      update(data) unless data.nil?
    end

    def update(data)
      data.each do |field_value|
        update_field(field_value.first, field_value.second)
      end
    end

    def use_endpoint(endpoint)
      @component[:controller] = "getBffApi"
      @component[:endpoint] = endpoint
      self
    end

    def to_h
      @component
    end

    def to_json
      @component.to_json
    end

    def self.render(data = nil)
      instance = self.new(data)
      instance.to_h
    end

    def self.create(data)
      component = self.new
      component.update(data)
    end

    private

    def create_sections
      component_fields.each do |prop|
        define_accessor_methods(prop.first)
      end
    end

    def define_accessor_methods(method_name)
      self.class.send(:define_method, method_name) do ||
        @component[method_name]
      end
      self.class.send(:define_method, "#{method_name}=") do |value|
        validate_fied(method_name, value)
        @component[method_name] = value
      end
    end

    def update_field(method_name, value)
      validate_fied(method_name, value)
      @component[method_name] = value
    end

    def component_fields
      self.class::FIELDS.merge(DEFAULT_FIELDS)
    end

    def validate_fied(name, value)

      return validate_boolean(name, value) if component_fields[name] == :boolean
      return validate_string(name, value) if component_fields[name] == :string
      return validate_number(name, value) if component_fields[name] == :number
      return validate_one_of(name, value) if component_fields[name].is_a?(Array)

      true
    end

    def validate_boolean(name, value)
      return nil if [true, false].include?(value)

      raise ArgumentError.new("#{name} should be a boolean")
    end

    def validate_string(name, value)
      return nil if value.is_a?(String) || value.is_a?(Numeric)

      raise ArgumentError.new("#{name} should be a string")
    end

    def validate_number(name, value)
      return nil if value.is_a?(String) || value.is_a?(Numeric)

      raise ArgumentError.new("#{name} should be a number")
    end

    def validate_one_of(name, value)
      return nil if self.class::FIELDS[name].include?(value.to_sym)

      error_message = "#{name} should be one of: #{self.class::FIELDS[name].to_s}"
      raise ArgumentError.new(error_message)
    end
  end
end
