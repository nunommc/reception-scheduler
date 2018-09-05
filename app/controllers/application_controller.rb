# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def collection
    set_collection_ivar(super.decorate)
  end
end
