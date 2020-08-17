# frozen_string_literal: true

module Recruitment
  class MeetingDate
    include Comparable

    attr_reader :date

    def initialize(date)
      raise Errors::MeetingDateInPast if Date.parse(date).past?

      self.date = date
    end

    def <=>(other)
      date <=> other.date
    end

    private

    attr_writer :date
  end
end
