# frozen_string_literal: true

module Recruitment
  class Candidate
    include AggregateRoot

    MeetingAlreadyScheduled = Class.new(StandardError)
    MeetingNotScheduled = Class.new(StandardError)

    def initialize(id)
      self.id = id
      self.meetings = []
    end

    def create(forename, surname)
      apply CandidateCreated.new(data:
        {
          candidate_id: id,
          forename: forename,
          surname: surname
        }
      )
    end

    def schedule_meeting(date)
      raise MeetingAlreadyScheduled if meetings.include?(date)

      apply MeetingScheduled.new(data: { candidate_id: id, date: date })
    end

    def cancel_meeting(date)
      raise MeetingNotScheduled if meetings.exclude?(date)

      apply MeetingCancelled.new(data: { candidate_id: id, date: date })
    end

    on CandidateCreated do |event|
      self.state = :new
    end

    on MeetingScheduled do |event|
      self.meetings += [event.date]
    end

    on MeetingCancelled do |event|
      self.meetings -= [event.date]
    end

    private

    attr_accessor :id, :state, :meetings, :forename, :surname
  end
end
