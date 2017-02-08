class HTTP::Server::Context
  property! flash : Kemal::Flash::FlashHash

  def flash : Kemal::Flash::FlashHash
    if @flash.nil?
      objs = session.objects
      f = uninitialized Kemal::Flash::FlashHash
      if !objs.nil? && objs.keys.includes?("flash")
        f = session.object("flash").as(Kemal::Flash::FlashHash)
      else
        f = Kemal::Flash::FlashHash.new
      end
      @flash = f
    end
    @flash.not_nil!
  end

  #:nodoc:
  def commit_flash!
    session.object("flash", flash)
  end
end
