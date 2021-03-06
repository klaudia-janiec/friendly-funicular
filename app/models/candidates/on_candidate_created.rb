# frozen_string_literal: true

module Candidates
  class OnCandidateCreated
    def call(event)
      Candidate.create!(
        uid: event.data[:candidate_id],
        state: event.data[:state],
        forename: event.data[:forename],
        surname: event.data[:surname]
      )
    end
  end
end
