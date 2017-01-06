module Kemal::Flash
  class FlashHash < Session::StorableObject
    JSON.mapping({
      values: Hash(String, String),
      discard: {type: Set(String), getter: false},
    })
    delegate each, empty?, keys, has_key?, delete, to_h, to: @values

    def initialize
      @values  = Hash(String, String).new
      @discard = Set(String).new
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

    def self.unserialize(val : String)
      flash_hash = self.from_json(val)
      flash_hash.sweep
      flash_hash
    end

    # Will remove any values that are in the discard set
    # and any keys that weren't rejected will now be up for
    # discard at the end of the current action
    #
    def sweep #:nodoc:
      @values.reject! { |x| @discard.includes?(x) }
      @discard = Set(String).new(@values.keys)
    end

    def serialize
      @values.delete_if { |x| @discard.includes?(x) }
      @discard.clear
      self.to_json
    end
  end
end
