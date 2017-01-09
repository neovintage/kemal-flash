require "json"
require "kemal"
require "kemal-session"
require "./kemal-flash/*"
require "./kemal-flash/ext/*"

# We have to recommit the flash to the session otherwise kemal-flash doesn't work
#
after_all do |context|
  context.commit_flash!
end
