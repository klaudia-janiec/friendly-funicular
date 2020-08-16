# frozen_string_literal: true

module Recruitment
  class CandidateCreated < Event
    attribute :candidate_id, Types::UUID
    attribute :forename, Types::Coercible::String
    attribute :surname, Types::Coercible::String
    attribute :state, Types::Coercible::String
  end
end
