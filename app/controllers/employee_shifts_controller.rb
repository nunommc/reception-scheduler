# frozen_string_literal: true

class EmployeeShiftsController < InheritedResources::Base
  def new
    @employee_shift = EmployeeShiftCreator.new
  end

  def create
    @employee_shift = EmployeeShiftCreator.new(employee_shift: employee_shift_params, day: params[:day], start_hour: params[:start_hour], end_hour: params[:end_hour])

    respond_to do |format|
      if @employee_shift.create!
        redirect_to employee_shifts_path
      else
        format.html { render :new }
      end
    end
  end

  def update
    update! { employee_shifts_path }
  end

  private

  def employee_shift_params
    params.require(:employee_shift).permit(:employee_id)
  end
end
