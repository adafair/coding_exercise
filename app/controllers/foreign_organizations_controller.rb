class ForeignOrganizationsController < ApplicationController
  def index
    @organizations = Organization.foreign # see Organization model for scope

    render :index
  end
end
