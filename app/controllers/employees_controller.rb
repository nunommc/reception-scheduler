# frozen_string_literal: true

class EmployeesController < InheritedResources::Base
  def create
    create! { employees_path }
  end

  def update
    update! { employees_path }
  end

  private

  def collection
    set_collection_ivar(super.decorate)
  end

  def employee_params
    params.require(:employee).permit(:name, :office_id)
  end
end
