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

    def accept_offer
      raise Errors::CandidateAlreadyHired if state == 'hired'
      raise Errors::OfferAlreadyAccepted if state == 'offer_accepted'

      apply OfferAccepted.new(data: { candidate_id: id, state: :offer_accepted })
    end

    def accept_candidate
      raise Errors::CandidateAlreadyHired if state == 'hired'
      raise Errors::CandidateAlreadyAccepted if state == 'candidate_accepted'

      apply CandidateAccepted.new(data: { candidate_id: id, state: :candidate_accepted })
    end

    def hire
      raise Errors::InvalidCandidateState if %w[offer_accepted candidate_accepted].exclude?(state)
      raise Errors::CandidateAlreadyHired if state == 'hired'

      apply CandidateHired.new(data: { candidate_id: id, state: :hired })
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

    on OfferAccepted do |event|
      self.state = event.state
    end

    on CandidateAccepted do |event|
      self.state = event.state
    end

    on CandidateHired do |event|
      self.state = event.state
    end

    private

    attr_accessor :id, :state, :meetings, :forename, :surname
  end
end
