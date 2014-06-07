module Jekyll
  class Converter < Plugin

    # Patch used to export site variable to converters
    def locals(locals=nil)
      @locals = locals if locals
      @locals
    end
  end
end
