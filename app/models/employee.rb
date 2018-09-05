# frozen_string_literal: true

class Employee < ApplicationRecord
  belongs_to :office
  has_many :employee_shifts

  validates_presence_of :name, :office
end
