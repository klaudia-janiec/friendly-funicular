# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cancelling meeting' do
  let(:command_bus) { Rails.configuration.command_bus }
  let(:command) { Recruitment::CancelMeeting.new(candidate_id: candidate_id, date: date) }
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
    command_bus.call(Recruitment::ScheduleMeeting.new(candidate_id: candidate_id, date: date))
    command_bus.call(command)

    expect(events).to contain_exactly(
      an_instance_of(Recruitment::CandidateCreated),
      an_instance_of(Recruitment::MeetingScheduled),
      an_instance_of(Recruitment::MeetingCancelled)
    )
    expect(events).to contain_exactly(
      have_attributes(data: { candidate_id: candidate_id, forename: 'Adam', surname: 'Mickiewicz', state: 'new' }),
      have_attributes(data: { candidate_id: candidate_id, meetings: [date], state: 'scheduled' }),
      have_attributes(data: { candidate_id: candidate_id, meetings: [], state: 'cancelled' })
    )
  end

  context 'when there are some meetings remaining' do
    it 'publishing proper message to event store', :aggregate_failures do
      command_bus.call(Recruitment::ScheduleMeeting.new(candidate_id: candidate_id, date: '19-01-2021'))
      command_bus.call(Recruitment::ScheduleMeeting.new(candidate_id: candidate_id, date: date))
      command_bus.call(command)

      expect(events).to contain_exactly(
        an_instance_of(Recruitment::CandidateCreated),
        an_instance_of(Recruitment::MeetingScheduled),
        an_instance_of(Recruitment::MeetingScheduled),
        an_instance_of(Recruitment::MeetingCancelled)
      )
      expect(events).to contain_exactly(
        have_attributes(data: { candidate_id: candidate_id, forename: 'Adam', surname: 'Mickiewicz', state: 'new' }),
        have_attributes(data: { candidate_id: candidate_id, meetings: ['19-01-2021'], state: 'scheduled' }),
        have_attributes(data: { candidate_id: candidate_id, meetings: ['19-01-2021', date], state: 'scheduled' }),
        have_attributes(data: { candidate_id: candidate_id, meetings: ['19-01-2021'], state: 'scheduled' })
      )
    end
  end

  context 'when there is no meeting on given date' do
    it 'raises proper error' do
      expect { command_bus.call(command) }.to raise_error(Recruitment::Errors::MeetingNotScheduled)
    end
  end

  context 'when date is in past' do
    before { command_bus.call(Recruitment::ScheduleMeeting.new(candidate_id: candidate_id, date: date)) }

    it 'raises proper error' do
      travel_back
      travel_to(Time.zone.local(2021, 1, 21)) do
        expect { command_bus.call(command) }.to raise_error(Recruitment::Errors::MeetingDateInPast)
      end
    end
  end
end
