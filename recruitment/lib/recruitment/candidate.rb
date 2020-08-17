# frozen_string_literal: true

module Recruitment
  class Candidate
    include AggregateRoot

    def initialize(id)
      self.id = id
      self.meetings = []
    end

    def create(forename, surname)
      apply CandidateCreated.new(data:
        {
          candidate_id: id,
          state: :new,
          forename: forename,
          surname: surname
        })
    end

    def schedule_meeting(date)
      meeting_date = MeetingDate.new(date)

      raise Errors::MeetingAlreadyScheduled if meetings.include?(meeting_date)

      new_state = :scheduled
      new_meetings = meetings + [meeting_date]
      apply MeetingScheduled.new(data: { candidate_id: id, state: new_state, meetings: new_meetings.map(&:date) })
    end

    def cancel_meeting(date)
      meeting_date = MeetingDate.new(date)

      raise Errors::MeetingNotScheduled if meetings.exclude?(meeting_date)

      new_meetings = meetings.reject { |entry| entry == meeting_date }
      new_state = new_meetings.empty? ? :cancelled : :scheduled
      apply MeetingCancelled.new(data: { candidate_id: id, state: new_state, meetings: new_meetings.map(&:date) })
    end

    on CandidateCreated do |event|
      self.state = event.state
    end

    on MeetingScheduled do |event|
      self.state = event.state
      self.meetings = event.meetings.map { |date| MeetingDate.new(date) }
    end

    on MeetingCancelled do |event|
      self.state = event.state
      self.meetings = event.meetings.map { |date| MeetingDate.new(date) }
    end

    private

    attr_accessor :id, :state, :meetings, :forename, :surname
  end
end
