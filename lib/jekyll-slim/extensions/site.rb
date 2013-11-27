require 'jekyll-slim/slim_context'

module Jekyll

  class Site

    attr_reader :slim_context

    # Patch to allow usage of site variable in Slim/Haml
    # https://blog.darmasoft.net/2012/02/29/haml-processing-in-jekyll.html
    # https://github.com/mojombo/jekyll/blob/master/lib/jekyll/site.rb
    def instantiate_subclasses(klass)
      klass.subclasses.select do |c|
        !self.safe || c.safe
      end.sort.map do |c|
        conv = c.new(self.config)
        # XXX: Hotfix to allow access site variable in slim/haml templates
        if conv.respond_to?(:locals)
          @slim_context ||= SlimContext.new(self)
          conv.locals({ slim_context: @slim_context })
        end
        
        conv
      end
    end

  end

end