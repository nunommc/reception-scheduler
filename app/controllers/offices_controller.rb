# frozen_string_literal: true

class OfficesController < InheritedResources::Base
  def create
    create! { offices_path }
  end

  def update
    update! { offices_path }
  end

  private

  def collection
    set_collection_ivar(super.decorate)
  end

  def office_params
    params.require(:office).permit(:name, :address, :opening_hour, :closing_hour, :nr_reception_desks)
  end
end
