# frozen_string_literal: true

module Recruitment
  class MeetingCancelled < Event
    attribute :candidate_id, Types::UUID
    attribute :meetings, Types::Array.of(Types::Nominal::Date)
    attribute :state, Types::Coercible::String
  end
end
