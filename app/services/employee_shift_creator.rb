# frozen_string_literal: true

class EmployeeShiftCreator
  attr_reader :day, :start_hour, :end_hour, :errors
  MAX_SHIFT_HOURS = 8
  MAXIMUM_WEEKLY_WORKING_HOURS = 40

  def initialize(shift:, day:, start_hour:, end_hour:)
    @start_time = Time.parse("#{day} #{start_hour}")
    @end_time = Time.parse("#{day} #{end_hour}")

    @start_hour = start_hour
    @end_hour = end_hour
    @shift_duration = TimeDifference.between(@start_time, @end_time).in_hours
    @errors = {}

    @employee_shift = EmployeeShift.new(shift.merge(start_time: @start_time, end_time: @end_time))
  end

  def create!
    @employee_shift.save! if valid?
  end

  def valid?
    validate_duration &&
      validate_shift_within_office_hours &&
      validate_weekly_working_hours &&
      validate_shift_is_available
    errors.empty?
  end

  private

  def validate_duration
    if @shift_duration > MAX_SHIFT_HOURS
      errors[:end_time] ||= []
      errors[:end_time] << "shift is longer than #{MAX_SHIFT_HOURS} hours"
      false
    end
    true
  end

  def validate_shift_within_office_hours
    if @start_hour < office.opening_hour
      errors[:start_time] ||= []
      errors[:start_time] << "office is not open until #{office.opening_hour}"
      return false
    end

    if @end_hour >= office.closing_hour
      errors[:end_time] ||= []
      errors[:end_time] << "office closes at #{office.closing_hour}"
      false
    end
    true
  end

  def validate_weekly_working_hours
    shifts_in_week = employee.employee_shifts.where(
      'start_time > ? AND end_time < ?',
      @start_time.beginning_of_week,
      @end_time.end_of_week
    )

    total_week_hours = shifts_in_week.sum do |s|
      TimeDifference.between(s.start_time, s.end_time).in_hours
    end

    if total_week_hours + @shift_duration > MAXIMUM_WEEKLY_WORKING_HOURS
      errors[:start_time] ||= []
      errors[:start_time] << "your working week has got already #{total_week_hours.to_i} hours"
      false
    end
    true
  end

  def validate_shift_is_available
    res = EmployeeShift.joins(:employee)
                       .where(employees: { office: office })
                       .where(
                         'start_time > ? AND end_time < ?',
                         @start_time.beginning_of_day,
                         @end_time.end_of_day
                       )
    nr_employees_with_shift = res.count do |s|
      s.start_time.hour > @start_hour && s.end_time.hour < @end_hour
    end

    if nr_employees_with_shift + 1 > office.nr_reception_desks
      errors[:start_time] ||= []
      errors[:start_time] << 'shift is taken'
      return false
    end
    true
  end

  def employee
    @employee_shift.employee
  end

  def office
    employee.office
  end
end
