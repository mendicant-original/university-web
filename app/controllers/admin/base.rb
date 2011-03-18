module Admin
  class Base < ApplicationController
    before_filter :admin_required
    before_filter { @selected = :administration }
    layout "admin"

  end
end
