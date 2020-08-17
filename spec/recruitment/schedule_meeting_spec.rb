# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Scheduling meeting' do
  let(:command_bus) { Rails.configuration.command_bus }
  let(:command) { Recruitment::ScheduleMeeting.new(candidate_id: candidate_id, date: date) }
  let(:date) { '20-01-2021' }
  let(:candidate_id) { SecureRandom.uuid }
  let(:stream) { "Recruitment::Candidate$#{candidate_id}" }

  let(:events) { Rails.configuration.event_store.read.stream(stream).each.to_a }

  before do
    travel_to Time.zone.local(2020, 8, 24)
    command_bus.call(
      Recruitment::CreateCandidate.new(candidate_id: candidate_id, forename: 'Adam', surname: 'Mickiewicz')
    )
  end

  it 'publishing proper message to event store', :aggregate_failures do
    command_bus.call(command)

    expect(events).to contain_exactly(
      an_instance_of(Recruitment::CandidateCreated),
      an_instance_of(Recruitment::MeetingScheduled)
    )
    expect(events).to contain_exactly(
      have_attributes(data: { candidate_id: candidate_id, forename: 'Adam', surname: 'Mickiewicz', state: 'new' }),
      have_attributes(data: { candidate_id: candidate_id, meetings: [date], state: 'scheduled' })
    )
  end

  context 'when meeting already scheduled on given date' do
    it 'raises proper error' do
      command_bus.call(command)

      expect { command_bus.call(command) }.to raise_error(Recruitment::Errors::MeetingAlreadyScheduled)
    end
  end

  context 'when date is in past' do
    let(:date) { '20-02-2020' }

    it 'raises proper error' do
      expect { command_bus.call(command) }.to raise_error(Recruitment::Errors::MeetingDateInPast)
    end
  end
end
