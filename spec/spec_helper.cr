require "spec"
require "spec-kemal"
require "../src/kemal-flash"

ENV["KEMAL_ENV"] = "test"

Session.config.engine = Session::MemoryEngine.new
Session.config.secret = "kemal_rocks"

# For testing cookie signing and for having a valid session
#
SESSION_SECRET = "b3c631c314c0bbca50c1b2843150fe33"
SESSION_ID     = SecureRandom.hex
SIGNED_SESSION = "#{SESSION_ID}--#{Session.sign_value(SESSION_ID)}"
headers = HTTP::Headers{"Cookie" => "kemal_sessid=#{SIGNED_SESSION}"}

module TestKemalApp
  get "/set_flash" do |context|
    context.flash["charlie"] = "snoopy"
    "made it"
  end

  get "/use_flash" do |context|
    context.flash["charlie"]
  end
end

Kemal.run
