# frozen_string_literal: true

FactoryBot.define do
  factory :office do
    name { 'an office' }
    opening_hour { 7 }
    closing_hour { 21 }
    nr_reception_desks { 1 }
  end
end
