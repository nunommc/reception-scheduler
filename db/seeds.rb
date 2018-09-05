# frozen_string_literal: true

office = Office.find_or_create_by(
  name: 'Shoreditch House',
  opening_hour: 7, closing_hour: 3,
  nr_reception_desks: 1
)

Employee.create(name: 'Nuno Costa', office: office)
