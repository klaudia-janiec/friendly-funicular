# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating candidate' do
  let(:command_bus) { Rails.configuration.command_bus }
  let(:command) do
    Recruitment::CreateCandidate.new(candidate_id: candidate_id, forename: 'Adam', surname: 'Mickiewicz')
  end
  let(:candidate_id) { SecureRandom.uuid }
  let(:stream) { "Recruitment::Candidate$#{candidate_id}" }

  let(:events) { Rails.configuration.event_store.read.stream(stream).each.to_a }

  before { command_bus.call(command) }

  it 'publishing proper message to event store', :aggregate_failures do
    expect(events).to all(be_an(Recruitment::CandidateCreated))
    expect(events).to contain_exactly(
      have_attributes(data: { candidate_id: candidate_id, forename: 'Adam', surname: 'Mickiewicz', state: 'new' })
    )
  end
end
