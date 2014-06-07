class SlimContext
  attr_accessor :params

  def initialize(site_context)
    # XXX: Hopefully user won't overwrite this instance variable
    @__site = site_context
  end

  def site
    @__site
  end
end
