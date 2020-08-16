# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def event_store
    Rails.configuration.event_store
  end

  def command_bus
    Rails.configuration.command_bus
  end
end
