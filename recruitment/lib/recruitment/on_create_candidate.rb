# frozen_string_literal: true

module Recruitment
  class OnCreateCandidate
    include CommandHandler

    def call(command)
      with_aggregate(Candidate, command.aggregate_id) do |candidate|
        candidate.create(command.forename, command.surname)
      end
    end
  end
end
