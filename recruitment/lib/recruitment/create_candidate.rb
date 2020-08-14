# frozen_string_literal: true

module Recruitment
  class CreateCandidate < Command
    attribute :candidate_id, Types::UUID
    attribute :forename, Types::Coercible::String
    attribute :surname, Types::Coercible::String

    alias :aggregate_id :candidate_id
  end
end
