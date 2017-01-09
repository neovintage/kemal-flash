class HTTP::Server::Context
  property! flash : Kemal::Flash::FlashHash

  def flash
    if !@flash
      objs = session.objects
      if !objs.nil? && objs.keys.includes?("flash")
        @flash = session.object("flash").as(Kemal::Flash::FlashHash)
      else
        @flash = Kemal::Flash::FlashHash.new
      end
    end
    @flash.not_nil!
  end

  #:nodoc:
  def commit_flash!
    session.object("flash", flash)
  end
end
