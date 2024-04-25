class HomeController < ApplicationController
  def index
    @email = current_admin.email
  end
end
