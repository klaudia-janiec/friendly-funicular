# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsEventStore::Browser => '/res' if Rails.env.development?
  
  resources :candidates, only: [:index, :show, :new, :create]
end
