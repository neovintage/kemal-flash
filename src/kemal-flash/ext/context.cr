class HTTP::Server::Context
  property! flash

  def flash
    @flash = session.object?("flash")
    @flash ||= FlashHash.new
    @flash.not_nil!
  end

  #:nodoc:
  def commit_flash!
    session.object("flash", @flash.as(Session::StorableObject))
  end
end
