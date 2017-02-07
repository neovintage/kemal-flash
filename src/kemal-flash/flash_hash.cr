module Kemal::Flash
  class BaseHash
    JSON.mapping({
      values: Hash(String, String),
      discard: {type: Set(String), getter: false},
    })
    delegate each, empty?, keys, has_key?, delete, to_h, to: @values

    def initialize
      @values  = Hash(String, String).new
      @discard = Set(String).new
    end
  end

  # This is a hack so that a callback mechanism exists when
  # serializing and deserializing the json for the flash
  # from session storage.
  #
  class FlashHash < BaseHash
    include Session::StorableObject

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
    def sweep #:nodoc:
      @values.reject!(@discard.to_a)
      @discard = Set(String).new(@values.keys)
    end

    def self.from_json(string_or_io)
      parser = JSON::PullParser.new(string_or_io)
      flash_hash = self.new(parser)
      flash_hash.sweep
      return flash_hash
    end

    def to_json
      @values.reject!(@discard.to_a)
      @discard.clear
      super
    end
  end
end
