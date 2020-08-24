# frozen_string_literal: true

module Recruitment
  class HireCandidate < Event
    attribute :candidate_id, Types::UUID

    alias aggregate_id candidate_id
  end
end
