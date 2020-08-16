# frozen_string_literal: true

module Recruitment
  class MeetingDate
    include Comparable

    attr_reader :date

    MeetingDateInPast = Class.new(StandardError)

    def initialize(date)
      raise MeetingDateInPast if Date.parse(date).past?

      self.date = date
    end

    def <=>(other)
      self.date <=> other.date
    end

    private

    attr_writer :date
  end
end
