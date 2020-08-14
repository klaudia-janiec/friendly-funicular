# frozen_string_literal: true

module Candidates
  class Candidate < ApplicationRecord
    self.table_name = 'candidates'

    serialize :meetings, Array
  end
end
