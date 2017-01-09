class HTTP::Server::Context
  property! flash : Kemal::Flash::FlashHash

  def flash
    if !@flash
      if session.objects.has_key?("flash")
        tmp_flash = session.object("flash").as(Kemal::Flash::FlashHash)
      else
        tmp_flash = Kemal::Flash::FlashHash.new
      end
    end
    @flash = tmp_flash
    @flash.not_nil!
  end

  #:nodoc:
  def commit_flash!
    #session.object("flash", flash)
  end
end
