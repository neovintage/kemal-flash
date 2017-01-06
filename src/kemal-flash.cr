require "json"
require "kemal"
require "kemal-session"
require "./kemal-flash/*"

# We have to recommit the flash to the session otherwise kemal-flash doesn't work
#
after_all do |context|
end
