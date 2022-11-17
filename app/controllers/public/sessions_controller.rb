# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]

  def after_sign_in_path_for(resource)
    mypage_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end


  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end


  protected

  def user_state
    @user = User.find_by(email: params[:user][:email])
    retrn if !@user
    if @user.valid_password?(params[:user][:password])&& (@user.is_deleted == true)
      # flash[:notice] = "アカウント凍結中です。お問い合わせください。"
      redirect_to "/", notice: "アカウント凍結中です。お問い合わせください"
    else
      flash[:notice] = "項目を入力してください"
    end
  end


  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
