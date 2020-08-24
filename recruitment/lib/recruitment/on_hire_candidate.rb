# frozen_string_literal: true

module Recruitment
  class OnHireCandidate
    include CommandHandler

    def call(command)
      with_aggregate(Candidate, command.aggregate_id) do |candidate|
        candidate.hire
      end
    end
  end
end
