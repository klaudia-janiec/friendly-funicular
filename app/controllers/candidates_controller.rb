# frozen_string_literal: true

class CandidatesController < ApplicationController
  around_action :rescue_recruitment_errors, ony: %i[schedule_meeting cancel_meeting accept_offer accept_candidate]

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

  def schedule_meeting
    @candidate = Candidates::Candidate.find_by(uid: params[:candidate_id])
    command = Recruitment::ScheduleMeeting.new(candidate_id: params[:candidate_id], date: params[:date])
    command_bus.call(command)

    redirect_to candidate_path(@candidate), notice: 'Candidate was successfully submitted.'
  end

  def cancel_meeting
    @candidate = Candidates::Candidate.find_by(uid: params[:candidate_id])
    command = Recruitment::CancelMeeting.new(candidate_id: params[:candidate_id], date: params[:date])
    command_bus.call(command)

    redirect_to candidate_path(@candidate), notice: 'Candidate was successfully submitted.'
  end

  def accept_offer
    @candidate = Candidates::Candidate.find_by(uid: params[:candidate_id])
    command = Recruitment::AcceptOffer.new(candidate_id: params[:candidate_id])
    command_bus.call(command)

    redirect_to candidate_path(@candidate), notice: 'Candidate accepted job offer.'
  end

  def accept_candidate
    @candidate = Candidates::Candidate.find_by(uid: params[:candidate_id])
    command = Recruitment::AcceptCandidate.new(candidate_id: params[:candidate_id])
    command_bus.call(command)

    redirect_to candidate_path(@candidate), notice: 'Employer accepted candidate.'
  end

  private

  def rescue_recruitment_errors
    yield
  rescue Recruitment::Errors::BaseError => e
    redirect_to candidate_path(@candidate), flash: { error: e.class.name.demodulize.underscore.humanize }
  end
end
