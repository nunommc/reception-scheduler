# frozen_string_literal: true

RSpec.describe 'creating an employee' do
  before do
    create :office, name: 'St Pauls'
    visit root_path
    click_on 'Employees'
    click_on 'New Employee'
  end

  it 'saves a new employee' do
    fill_in 'Name', with: 'an employee'
    select('St Pauls', from: 'employee_office_id')
    click_on 'Create Employee'

    within 'table.employees' do
      expect(page).to have_content 'an employee'
      expect(page).to have_content 'St Pauls'
    end
  end

  context 'with invalid input' do
    it 'displays errors' do
      fill_in 'Name', with: ''
      click_on 'Create Employee'

      expect(page).to have_content("Name can't be blank")
    end
  end
end
