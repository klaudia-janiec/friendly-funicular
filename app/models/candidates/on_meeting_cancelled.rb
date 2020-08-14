# frozen_string_literal: true

module Candidates
  class OnMeetingCancelled
    def call(event)
      candidate = Candidate.find_by(uid: event[:candidate_id])
      candidate.meetings -= [event[:date]]
      candidate.save!
    end
  end
end
