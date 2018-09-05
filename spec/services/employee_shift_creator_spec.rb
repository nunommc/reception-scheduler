# frozen_string_literal: true

RSpec.describe EmployeeShiftCreator do
  let(:office) { create(:office) }
  let(:employee) { create(:employee, office: office) }
  let(:employee_shift_params) do
    {
      employee_id: employee.id
    }
  end

  let(:day) { '2018-09-05' }
  let(:start_hour) { 9 }
  let(:end_hour) { 14 }

  subject { described_class.new(shift: employee_shift_params, day: day, start_hour: start_hour, end_hour: end_hour) }

  context 'when is correct' do
    it 'saves all attributes' do
      subject.create!
      new_record = EmployeeShift.last
      expect(new_record).to have_attributes(
        employee_id: employee.id,
        start_time: Time.parse('2018-09-05 9:00'),
        end_time: Time.parse('2018-09-05 14:00')
      )
    end
  end

  context 'when shift is too long' do
    let(:end_hour) { 18 }

    it "doesn't save the record" do
      subject.create!
      expect(EmployeeShift.last).to be_nil
      expect(subject.errors[:end_time]).to include('shift is longer than 8 hours')
    end
  end

  context 'when office is not open yet' do
    let(:office) { create(:office, opening_hour: 10) }

    it "doesn't save the record" do
      subject.create!
      expect(EmployeeShift.last).to be_nil
      expect(subject.errors[:start_time]).to include('office is not open until 10')
    end
  end

  context 'when office has already closed' do
    let(:office) { create(:office, closing_hour: 14) }

    it "doesn't save the record" do
      subject.create!
      expect(EmployeeShift.last).to be_nil
      expect(subject.errors[:end_time]).to include('office closes at 14')
    end
  end

  describe 'weekly working hours' do
    context 'when max amount has been reached' do
      before do
        [
          { start: '2018-08-20 9:00', end: '2018-08-20 17:00' }, # M
          { start: '2018-08-21 9:00', end: '2018-08-21 17:00' }, # T
          { start: '2018-08-22 9:00', end: '2018-08-22 15:00' }, # W
          { start: '2018-08-23 9:00', end: '2018-08-23 17:00' }, # T
          { start: '2018-08-24 9:00', end: '2018-08-24 15:00' }, # F
        ].each do |shifts|
          employee.employee_shifts.create(start_time: shifts[:start], end_time: shifts[:end])
        end
      end
      let(:day) { '2018-08-25' } # Saturday

      it 'fails to add a new shift' do
        subject.create!
        expect(subject.errors[:start_time]).to include('your working week has got already 36 hours')
      end
    end

    context 'when is possible to work another day' do
      before do
        [
          { start: '2018-08-20 9:00', end: '2018-08-20 17:00' }, # M
          { start: '2018-08-21 9:00', end: '2018-08-21 13:00' }, # T
          { start: '2018-08-22 9:00', end: '2018-08-22 15:00' }, # W
          { start: '2018-08-23 9:00', end: '2018-08-23 17:00' }, # T
          { start: '2018-08-24 9:00', end: '2018-08-24 15:00' }, # F
        ].each do |shifts|
          employee.employee_shifts.create(start_time: shifts[:start], end_time: shifts[:end])
        end
      end
      let(:day) { '2018-08-25' } # Saturday

      it 'adds a new shift' do
        subject.create!
        expect(subject.errors).to be_empty

        new_record = EmployeeShift.last
        expect(new_record).to have_attributes(
          employee_id: employee.id,
          start_time: Time.parse('2018-08-25 9:00'),
          end_time: Time.parse('2018-08-25 14:00')
        )
      end
    end
  end

  describe 'shift is available' do
    let!(:employee2) { create(:employee, office: office) }

    before do
      employee2.employee_shifts.create(start_time: "#{day} #{start_hour2}", end_time: "#{day} #{end_hour2}")
    end

    context 'when a shift already exists within the chosen slot' do
      let(:start_hour2) { 10 }
      let(:end_hour2) { 12 }

      it 'fails to add a new shift' do
        subject.create!
        expect(subject.errors[:start_time]).to include('shift is taken')
      end
    end
  end
end
