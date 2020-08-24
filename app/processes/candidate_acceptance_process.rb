# frozen_string_literal: true

class CandidateAcceptanceProcess
  def initialize(store: Rails.configuration.event_store, bus: Rails.configuration.command_bus)
    self.store = store
    self.bus = bus
  end

  def call(event)
    if both_acceptances?(event)
      bus.call(Recruitment::HireCandidate.new(candidate_id: event.data[:candidate_id]))
    end
  end

  private

  attr_accessor :store, :bus

  def both_acceptances?(event)
    missing_acceptance = event.is_a?(Recruitment::OfferAccepted) ? Recruitment::CandidateAccepted : Recruitment::OfferAccepted
    
    events(event).find { |entry| entry.is_a?(missing_acceptance) }
  end

  def events(event)
    stream_name = "CandidateProcess$#{event.data[:candidate_id]}"
    past = store.read.stream(stream_name).to_a
    last_stored = past.size - 1
    store.link(event.event_id, stream_name: stream_name, expected_version: last_stored)


    past

  rescue RubyEventStore::WrongExpectedVersion
    retry
  end
end
