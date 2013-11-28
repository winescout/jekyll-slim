require 'slim'

module Jekyll
  class SlimPartialTag < Liquid::Tag

    SYNTAX_EXAMPLE = "{% slim file.slim param='value' param2='value' %}"

    VALID_SYNTAX = /([\w-]+)\s*=\s*(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))/ 

    def initialize(tag_name, markup, tokens)
      super
      @file, @params = markup.strip.split(' ', 2)
      validate_params if @params
    end

    def validate_params
      full_valid_syntax = Regexp.compile('\A\s*(?:' + VALID_SYNTAX.to_s + '(?=\s|\z)\s*)*\z')
      unless @params =~ full_valid_syntax
        raise ArgumentError.new <<-eos
Invalid syntax for include tag:

      #{@params}

Valid syntax:

      #{SYNTAX_EXAMPLE}

eos
      end
    end

    def parse_params(context)
      params = {}
      markup = @params

      while match = VALID_SYNTAX.match(markup) do
        markup = markup[match.end(0)..-1]

        value = if match[2]
          match[2].gsub(/\\"/, '"')
        elsif match[3]
          match[3].gsub(/\\'/, "'")
        elsif match[4]
          slim_context[match[4]]
        end

        params[match[1]] = value
      end
      params
    end

    def render(context)
      includes_dir = File.join(context.registers[:site].source, '_includes')

      if File.symlink?(includes_dir)
        return "Includes directory '#{includes_dir}' cannot be a symlink"
      end

      if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
        return "Include file '#{@file}' contains invalid characters or sequences"
      end

      return "File must have \".slim\" extension" if @file !~ /\.slim$/

      Dir.chdir(includes_dir) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(@file)
          source = File.read(@file)
          context.registers[:site].slim_context.params = parse_params(context.registers[:site].slim_context)
          conversion = ::Slim::Template.new(context.registers[:site].config['slim'].deep_symbolize_keys) { source }.render(context.registers[:site].slim_context)
          partial = Liquid::Template.parse(conversion)
          begin
            return partial.render!(context)
          rescue => e
            if self.respond_to?(:data)
              puts "Liquid Exception: #{e.message} in #{self.data["layout"]}"
            else
              puts "Liquid Exception: #{e.message} in (Unknown layout)"
            end
            e.backtrace.each do |backtrace|
              puts backtrace
            end
            abort("Build Failed")
          end

          context.stack do
            return partial.render(context)
          end
        else
          "Included file '#{@file}' not found in _includes directory"
        end
      end
    end
  end
end

Liquid::Template.register_tag('slim', Jekyll::SlimPartialTag)
