# frozen_string_literal: true

module Recruitment
  class Meeting
    def initialize(candidate_id, date)
      self.candidate_id = candidate_id
      self.date = date
    end

    private

    attr_accessor :candidate_id, :date
  end
end
