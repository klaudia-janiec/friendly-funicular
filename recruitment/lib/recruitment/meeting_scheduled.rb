# frozen_string_literal: true

module Recruitment
  class MeetingScheduled < Event
    attribute :candidate_id, Types::UUID
    attribute :date, Types::Nominal::Date
  end
end
