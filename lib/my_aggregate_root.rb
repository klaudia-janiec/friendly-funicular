# frozen_string_literal: true

module MyAggregateRoot
  attr_reader :version, :unpublished_events

  def self.included(base)
    base.extend(ClassMethods)
  end

  def apply(event)
    AggregateRoot::DefaultApplyStrategy.new.call(self, event)
    @unpublished_events << event
  end

  def version=(value)
    @unpublished_events = []
    @version = value
  end

  module ClassMethods
    def new(*)
      super.tap do |instance|
        instance.instance_variable_set(:@version, -1)
        instance.instance_variable_set(:@unpublished_events, [])
      end
    end

    def on(event_klass, &block)
      name = event_klass.to_s
      handler_name = "on_#{name}"

      define_method(handler_name, &block)
      @on_methods ||= {}
      @on_methods[name] = handler_name
      private(handler_name)
    end

    def on_methods
      @on_methods ||= {}
      (superclass.respond_to?(:on_methods) ? superclass.on_methods : {}).merge(@on_methods)
    end
  end
end
