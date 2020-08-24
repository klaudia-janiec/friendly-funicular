# frozen_string_literal: true

module Candidates
  class OnCandidateAccepted
    def call(event)
      Candidate.find_by(uid: event[:candidate_id]).update!(state: event[:state])
    end
  end
end
