# frozen_string_literal: true

module Recruitment
  class ScheduleMeeting < Command
    attribute :candidate_id, Types::UUID
    attribute :date, Types::Nominal::Date

    alias :aggregate_id :candidate_id
  end
end
