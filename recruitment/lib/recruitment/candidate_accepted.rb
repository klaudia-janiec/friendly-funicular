# frozen_string_literal: true

module Recruitment
  class CandidateAccepted < Event
    attribute :candidate_id, Types::UUID
    attribute :state, Types::Coercible::String
  end
end
