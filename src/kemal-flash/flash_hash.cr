require "json"

module Kemal::Flash
  class FlashHash
    include JSON::Serializable

    property values : Hash(String, String)
    setter discard : Set(String)

    delegate each, empty?, keys, has_key?, delete, to_h, to: @values

    def initialize
      @values = Hash(String, String).new
      @discard = Set(String).new
    end

    # Define own's version #from_json method use self.new(parser | JSON::PullParser)
    # for self-defined type which defined by JSON::Serializable module.
    def self.from_json(string_or_io)
      parser = JSON::PullParser.new(string_or_io)
      flash_hash = self.new(parser)
      flash_hash.sweep

      flash_hash
    end

    # # Define own's version #to_json method use to_json(builder : JSON::Builder)
    # # for self-defind type which defind by JSON::Serializable module.
    # def to_json
    #   JSON.build do |json|
    #     to_json(json)
    #   end
    # end

    include Session::StorableObject

    def to_json(json : JSON::Builder)
      @values.reject!(@discard.to_a)
      @discard.clear

      json.object do
        json.field "values" { json.object {
          @values.each do |k, v|
            json.field k, v
          end
        } }
        json.field "discard" { json.array {
          @discard.each do |k|
            json.scalar(k)
          end
        } }
      end
    end

    def update(h : Hash(String, String))
      @discard.subtract h.keys
      @values.merge!(h)
    end

    def []=(k : String, val : String)
      @values[k] = val
      @discard.delete(k)
    end

    def [](k : String)
      @discard.add(k)
      @values[k]
    end

    def []?(k : String)
      @discard.add(k)
      @values[k]?
    end

    # Discards the key at the end of the current action
    #
    def discard(key : String)
      @discard.add(key)
    end

    # Discards all keys at the end of the current action
    #
    def discard
      @discard.merge!(@values.keys)
    end

    # Will remove any values that are in the discard set
    # and any keys that weren't rejected will now be up for
    # discard at the end of the current action
    #
    def sweep # :nodoc:
      @values.reject!(@discard.to_a)
      @discard = Set(String).new(@values.keys)
    end
  end
end

10
