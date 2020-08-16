# frozen_string_literal: true

module Candidates
  class OnMeetingCancelled
    def call(event)
      Candidate.find_by(uid: event[:candidate_id]).update!(meetings: event[:meetings], state: event[:state])
    end
  end
end
