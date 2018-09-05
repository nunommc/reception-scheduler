# frozen_string_literal: true

class EmployeeDecorator < Draper::Decorator
  delegate_all

  def office
    object.office.name
  end
end
