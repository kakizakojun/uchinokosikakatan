# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  before_action :authenticate_admin!
  before_action :configure_sign_in_params, only: [:create]
  # before_action :confirm_admin
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_in_path_for(resource)
    admin_users_path
  end

  def after_sign_out_path_for(resource)
    new_admin_session_path
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end

  # def confirm_admin
  #   if current_admin.name == "ゲスト"
  #     redirect_to mypage_path
  #   end
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
