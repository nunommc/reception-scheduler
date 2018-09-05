# frozen_string_literal: true

class CreateOffices < ActiveRecord::Migration[5.2]
  def change
    create_table :offices do |t|
      t.string :name
      t.text :address
      t.integer :opening_hour
      t.integer :closing_hour
      t.integer :nr_reception_desks
    end
  end
end
