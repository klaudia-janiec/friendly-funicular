# frozen_string_literal: true

module Recruitment
  class MeetingCancelled < Event
    attribute :candidate_id, Types::UUID
    attribute :date, Types::Nominal::Date
  end
end
