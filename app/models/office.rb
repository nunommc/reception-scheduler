# frozen_string_literal: true

class Office < ApplicationRecord
  validates_presence_of :name,
                        :opening_hour,
                        :closing_hour,
                        :nr_reception_desks
end
