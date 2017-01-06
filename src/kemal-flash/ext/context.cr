class HTTP::Server::Context
  property! flash

  def flash
    # this is not right. need to check the session, hydrate flashhash and then return
    @flash ||= FlashHash.new(session)
    @flash.not_nil!
  end

  #:nodoc:
  def commit_flash
    session.object("flash", @flash)
  end
end
