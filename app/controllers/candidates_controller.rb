# frozen_string_literal: true

class CandidatesController < ApplicationController
  def index
    @candidates = Candidates::Candidate.all
  end

  def show
    @candidate = Candidates::Candidate.find(params[:id])
  end

  def new
    @candidate_id = SecureRandom.uuid
  end

  def create
    command = Recruitment::CreateCandidate.new(
      candidate_id: params[:candidate_id],
      forename: params[:forename],
      surname: params[:surname]
    )
    command_bus.call(command)
    candidate = Candidates::Candidate.find_by(uid: command.candidate_id)

    redirect_to candidate_path(candidate), notice: 'Candidate was successfully submitted.'
  end

  # rubocop:disable Metrics/AbcSize
  def schedule_meeting
    candidate = Candidates::Candidate.find_by(uid: params[:candidate_id])
    command = Recruitment::ScheduleMeeting.new(candidate_id: params[:candidate_id], date: params[:date])
    command_bus.call(command)

    redirect_to candidate_path(candidate), notice: 'Candidate was successfully submitted.'
  rescue Recruitment::Candidate::MeetingAlreadyScheduled, Recruitment::MeetingDate::MeetingDateInPast => e
    redirect_to candidate_path(candidate), notice: e.class.name.demodulize.underscore.humanize
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def cancel_meeting
    candidate = Candidates::Candidate.find_by(uid: params[:candidate_id])
    command = Recruitment::CancelMeeting.new(candidate_id: params[:candidate_id], date: params[:date])
    command_bus.call(command)

    redirect_to candidate_path(candidate), notice: 'Candidate was successfully submitted.'
  rescue Recruitment::Candidate::MeetingNotScheduled, Recruitment::MeetingDate::MeetingDateInPast => e
    redirect_to candidate_path(candidate), notice: e.class.name.demodulize.underscore.humanize
  end
  # rubocop:enable Metrics/AbcSize
end
