# frozen_string_literal: true

module Recruitment
  class Candidate
    include AggregateRoot

    CandidateDeactivatedError = Class.new(StandardError)

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

    def schedule_meeting(_date)
      raise CandidateDeactivatedError if state == :inactive
    end

    def cancel_meeting(date); end

    on CandidateCreated do |event|
      self.state = :new
    end

    private

    attr_accessor :id, :state, :meetings, :forename, :surname
  end
end
