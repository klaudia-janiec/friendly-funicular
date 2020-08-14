# frozen_string_literal: true

module Recruitment
  class OnCancelMeeting
    include CommandHandler

    def call(command)
      with_aggregate(Candidate, command.aggregate_id) do |candidate|
        candidate.cancel_meeting(command.date)
      end
    end
  end
end
