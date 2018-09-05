# frozen_string_literal: true

class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :name
      t.references :office, foreign_key: true
    end
  end
end
