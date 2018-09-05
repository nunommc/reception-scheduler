# frozen_string_literal: true

class CreateEmployeeShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_shifts do |t|
      t.references :employee, foreign_key: true

      t.datetime :start_time
      t.datetime :end_time
    end
  end
end
