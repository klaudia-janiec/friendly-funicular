# frozen_string_literal: true

require 'time'

class Event < Dry::Struct
  transform_keys(&:to_sym)

  def self.new(data: {}, metadata: {}, **rest)
    timestamp = begin
                  Time.parse(metadata.delete(:timestamp))
                rescue StandardError
                  nil
                end
    super(rest.merge(data).merge(metadata: metadata.merge(timestamp: timestamp)))
  end

  def self.inherited(klass)
    super
    klass.attribute :metadata, (Types.Constructor(RubyEventStore::Metadata).default { RubyEventStore::Metadata.new })
    klass.attribute :event_id, (Types::UUID.default { SecureRandom.uuid })
  end

  def to_h
    {
      event_id: event_id,
      metadata: metadata,
      data: super.except(:event_id, :metadata)
    }
  end

  def timestamp
    metadata[:timestamp]
  end

  def data
    to_h[:data]
  end

  def event_type
    self.class.name
  end

  def ==(other)
    other.instance_of?(self.class) &&
      other.event_id.eql?(event_id) &&
      other.data.eql?(data)
  end

  alias eql? ==
end
