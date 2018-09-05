# frozen_string_literal: true

RSpec.describe 'creating an office' do
  before do
    visit root_path
    click_on 'New Office'
  end

  it 'saves a new office' do
    fill_in 'Name', with: 'St Pauls'
    fill_in 'Opening hour', with: '9'
    fill_in 'Closing hour', with: '23'
    fill_in 'Nr reception desks', with: '1'
    click_on 'Create Office'

    within 'table.offices' do
      expect(page).to have_content 'St Pauls'
      expect(page).to have_content '9-23'
    end
  end

  context 'with invalid input' do
    it 'displays errors' do
      fill_in 'Name', with: ''
      click_on 'Create Office'

      expect(page).to have_content("Name can't be blank")
    end
  end
end
