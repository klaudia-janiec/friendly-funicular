# frozen_string_literal: true

module Recruitment
  class OnAcceptOffer
    include CommandHandler

    def call(command)
      with_aggregate(Candidate, command.aggregate_id) do |candidate|
        candidate.accept_offer
      end
    end
  end
end
