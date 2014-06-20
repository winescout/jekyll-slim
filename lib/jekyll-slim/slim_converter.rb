require 'slim'
require 'active_support/core_ext/hash'

module Jekyll
  class SlimConverter < Converter
    safe false
    priority :low

    def initialize(config)
      super
      self.ensure_config_integrity
    end

    def matches(ext)
      ext =~ /slim/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      begin
        ::Slim::Template.new(@symbolized_config) { content }.render(locals[:slim_context])
      rescue StandardError => e
        puts "(!) SLIM ERROR: " + e.message
      end
    end

    def ensure_config_integrity
      @config['slim'] ||= {}
      @symbolized_config = @config['slim'].deep_symbolize_keys
    end
  end
end
