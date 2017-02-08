require "spec"
require "spec-kemal"
require "../src/kemal-flash"

ENV["KEMAL_ENV"] = "test"

Kemal.config.logging  = false
Session.config.engine = Session::MemoryEngine.new
Session.config.secret = "kemal_rocks"

module TestKemalApp
  get "/set_flash" do |context|
    context.flash["charlie"] = "snoopy"
    "made it"
  end

  get "/use_flash" do |context|
    context.flash["charlie"]?
  end

  get "/use_flash_and_update_it" do |context|
    context.flash["charlie"]?
    context.flash["lucy"] = "linus"
  end

  get "/flash_json" do |context|
    context.flash.to_json
  end

  get "/redirect" do |context|
    context.flash["schroeder"] = "sally"
    context.redirect "/flash_json"
  end
end

Kemal.run
