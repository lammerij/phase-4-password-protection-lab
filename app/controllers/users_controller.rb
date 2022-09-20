class UsersController < ApplicationController
  before_action :user_data_not_found, only: [:show]

  def create
    new_user = User.create(user_params)
    if new_user.valid?
      session[:user_id] = new_user.id
      render json: new_user, status: :created
    else
      render json: { error: :user_data_invalid }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(id: session[:user_id])
    render json: user
  end

  private

  def user_data_invalid(error_hash)
    render json: { errors: error_hash.record.errors.full_messages }, status: :unprocessable_entity
  end

  def user_data_not_found
    render json: { error: "Not authorized." }, status: :unauthorized unless session.include? :user_id
  end

  def user_params
    params.permit(:username, :password, :password_confirmation, :id)
  end
end
