# frozen_string_literal: true

require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  Rails.configuration.event_store.tap do |store|
    store.subscribe(Candidates::OnCandidateCreated, to: [Recruitment::CandidateCreated])
    store.subscribe(Candidates::OnMeetingScheduled, to: [Recruitment::MeetingScheduled])
    store.subscribe(Candidates::OnMeetingCancelled, to: [Recruitment::MeetingCancelled])
    store.subscribe(Candidates::OnOfferAccepted, to: [Recruitment::OfferAccepted])
    store.subscribe(Candidates::OnCandidateAccepted, to: [Recruitment::CandidateAccepted])
    store.subscribe(Candidates::OnCandidateHired, to: [Recruitment::CandidateHired])

    store.subscribe(CandidateAcceptanceProcess, to:[
      Recruitment::OfferAccepted,
      Recruitment::CandidateAccepted
    ])
  end

  Rails.configuration.command_bus.tap do |bus|
    bus.register(Recruitment::CreateCandidate, Recruitment::OnCreateCandidate.new)
    bus.register(Recruitment::ScheduleMeeting, Recruitment::OnScheduleMeeting.new)
    bus.register(Recruitment::CancelMeeting, Recruitment::OnCancelMeeting.new)
    bus.register(Recruitment::AcceptOffer, Recruitment::OnAcceptOffer.new)
    bus.register(Recruitment::AcceptCandidate, Recruitment::OnAcceptCandidate.new)
    bus.register(Recruitment::HireCandidate, Recruitment::OnHireCandidate.new)
  end
end
