require "spec"
require "spec-kemal"
require "../src/kemal-flash"

module TestKemalApp
  get "/set_flash" do |context|
    context.flash["charlie"] = "snoopy"
    "made it"
  end

  get "/use_flash" do |context|
    context.flash["charlie"]
  end
end
