class UsersController < ApplicationController
  before_action :verify_user!, only: [:edit, :update, :show]
  before_action :find_user, only: [:edit, :update, :show]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:sucsess] = t "signup_success_mess" 
      redirect_to root_path
    else 
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params 
      flash[:success] = t "profile_update" 
      redirect_to @user
    else
      render :edit
    end
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find params[:id] 
  end  
end
