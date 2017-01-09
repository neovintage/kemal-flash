require "./spec_helper"

describe Kemal::Flash do
  it "should use flash" do
    get "/set_flash"
    get "/use_flash"
    response.body.should eq("snoopy")

    #get "/use_flash"
    #response.body.should eq("")
  end

  #it "should handle updates to flash"

  #it "should use new flash after session is cleared"

  #it "should keep flash on a redirect"
end
