# frozen_string_literal: true

Rails.application.routes.draw do
  root 'calendars#new'
  resources :calendars, only: %i[create]
end
