# frozen_string_literal: true

class OfficeDecorator < Draper::Decorator
  delegate_all

  def opening_hours
    [object.opening_hour, object.closing_hour].join('-')
  end
end
