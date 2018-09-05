# frozen_string_literal: true

Rails.application.routes.draw do
  resources :offices, except: :destroy
  resources :employees
  resources :employee_shifts

  root 'offices#index'
end
