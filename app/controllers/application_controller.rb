class ApplicationController < ActionController::Base
	skip_before_action :verify_authenticity_token

	rescue_from ActiveRecord::RecordInvalid do |e|
		render json: serialized_errors(e), status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: not_found_error(e), status: :not_found
  end

  private

  def serialized_errors(e)
    InvalidModel::Serializer.new(
      e.record,
      each_serializer: InvalidModel::ErrorSerializer,
    ).serializable_hash
  end

  def not_found_error(e)
    {
      errors: [
        code: 'not_found_error',
        detail: e.message,
        status: :not_found,
      ]
    }
  end
end
