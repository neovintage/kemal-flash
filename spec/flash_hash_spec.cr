require "./spec_helper"

include Kemal::Flash

describe FlashHash do
  it "should set and get a value" do
    flash_hash = FlashHash.new
    flash_hash["whatever"] = "asdf"
    flash_hash["whatever"].should eq("asdf")
  end

  it "should return keys" do
    fh = FlashHash.new
    fh["chuck"] = "snoopy"
    fh.keys.should eq(["chuck"])

    fh["lucy"]  = "linus"
    fh.keys.sort.should eq(["chuck", "lucy"])
  end

  it "should update" do
    fh = FlashHash.new
    fh["chuck"] = "snoopy"
    fh.update({ "chuck" => "linus", "lucy" => "sally" })

    fh["lucy"].should eq("sally")
    fh["chuck"].should eq("linus")
  end

  it "should test if key exists" do
    fh = FlashHash.new
    fh.has_key?("chuck").should eq(false)
    fh["chuck"] = ""
    fh.has_key?("chuck").should eq(true)
  end

  it "should delete a value" do
    fh = FlashHash.new
    fh["chuck"] = "snoopy"
    fh.delete("chuck")
    expect_raises(KeyError) do
      fh["chuck"]
    end
  end

  it "can return a hash" do
    fh = FlashHash.new
    fh["chuck"] = "snoopy"
    fh.to_h.should eq({ "chuck" => "snoopy" })
  end

  it "can be serialized as a StorableObject" do
    fh = FlashHash.new
    fh["chuck"] = "snoopy"
    fh.to_json.should eq("{\"values\":{\"chuck\":\"snoopy\"},\"discard\":[]}")

    fh.discard("chuck")
    fh.to_json.should eq("{\"values\":{},\"discard\":[]}")

    fh.discard("linus")
    fh.to_json.should eq("{\"values\":{},\"discard\":[]}")
  end

  it "can be unserialized as a StorableObject" do
    fh = FlashHash.from_json("{\"values\":{\"chuck\":\"snoopy\"},\"discard\":[]}")
    fh.to_h.should eq({ "chuck" => "snoopy" })
    fh.to_json.should eq("{\"values\":{},\"discard\":[]}")
  end

  it "can be unserialized as a StorableObject when discard exists" do
    fh = FlashHash.from_json("{\"values\":{\"chuck\":\"snoopy\"},\"discard\":[\"chuck\"]}")
    fh.to_h.should eq({} of String => String)
  end

  it "can tell you if its empty" do
    fh = FlashHash.new
    fh.empty?.should be_true

    fh["asdf"] = "something"
    fh.empty?.should be_false
  end

  it "can iterate over the flash" do
    fh = FlashHash.new
    fh["chuck"] = "snoopy"
    fh["lucy"]  = "linus"

    count = 0
    fh.each do |k, v|
      count += 1
      ["chuck", "lucy"].includes?(k)
    end
    count.should eq(2)
  end
end
