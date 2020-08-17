# frozen_string_literal: true

module Recruitment
  class Errors
    BaseError = Class.new(StandardError)

    MeetingAlreadyScheduled = Class.new(BaseError)
    MeetingNotScheduled = Class.new(BaseError)
    MeetingDateInPast = Class.new(BaseError)
  end
end
