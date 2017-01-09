require "spec"
require "spec-kemal"
require "../src/kemal-flash"

Session.config.engine = Session::MemoryEngine.new
Session.config.secret = "kemal_rocks"

module TestKemalApp
  get "/set_flash" do |context|
    context.flash["charlie"] = "snoopy"
    puts context.session.id
    "made it"
  end

  get "/use_flash" do |context|
    puts context.session.id
    context.flash["charlie"]
  end
end

Kemal.run
