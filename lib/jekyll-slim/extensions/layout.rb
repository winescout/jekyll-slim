module Jekyll
  class Layout

    # Allows layouts to be transformed by slim until this is fixed (1.4)
    # https://github.com/mojombo/jekyll/issues/225
    # https://github.com/mojombo/jekyll/blob/master/lib/jekyll/layout.rb
    def initialize(site, base, name)
      @site = site
      @base = base
      @name = name

      self.data = {}

      self.process(name)
      self.read_yaml(base, name)
      self.transform
    end
  end
end
