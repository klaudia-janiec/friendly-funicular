# frozen_string_literal: true

module Recruitment
  class OnAcceptCandidate
    include CommandHandler

    def call(command)
      with_aggregate(Candidate, command.aggregate_id) do |candidate|
        candidate.accept_candidate
      end
    end
  end
end
