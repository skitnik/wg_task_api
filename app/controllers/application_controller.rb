# frozen_string_literal: true

class ApplicationController < ActionController::API
  include AuthorizeRequest

  before_action :authorize_request, unless: -> { request.path.start_with?('/auth') }

  def render_not_found_error
    render json: { error: 'Record not found' }, status: :not_found
  end
end
