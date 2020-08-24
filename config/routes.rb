# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsEventStore::Browser => '/res' if Rails.env.development?

  resources :candidates, only: %i[index show new create] do
    member do
      post :schedule_meeting
      post :cancel_meeting
      post :accept_offer
      post :accept_candidate
    end
  end
end
