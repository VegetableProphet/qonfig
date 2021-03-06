# frozen_string_literal: true

# @api private
# @since 0.20.0
class Qonfig::Validation::Validators::ProcBased < Qonfig::Validation::Validators::Basic
  # @return [Proc]
  #
  # @api private
  # @since 0.20.0
  attr_reader :validation

  # @param setting_key_matcher [Qonfig::Settings::KeyMatcher, NilClass]
  # @param strict [Boolean]
  # @param vaidation [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.20.0
  def initialize(setting_key_matcher, strict, validation)
    super(setting_key_matcher, strict)
    @validation = validation
  end

  # @param data_set [Qonfig::DataSet]
  # @return [Boolean]
  #
  # @raise [Qonfig::ValidationError]
  #
  # @api private
  # @since 0.20.0
  def validate_concrete(data_set)
    data_set.settings.__deep_each_setting__ do |setting_key, setting_value|
      next unless setting_key_matcher.match?(setting_key)
      next if !strict && setting_value.nil?

      raise(
        Qonfig::ValidationError,
        "Invalid value of setting <#{setting_key}> (#{setting_value})"
      ) unless data_set.instance_exec(setting_value, &validation)
    end
  end

  # @param data_set [Qonfig::DataSet]
  # @return [Boolean]
  #
  # @raise [Qonfig::ValidationError]
  #
  # @api private
  # @since 0.20.0
  def validate_full(data_set)
    unless data_set.instance_eval(&validation)
      raise(Qonfig::ValidationError, 'Invalid config object')
    end
  end
end
