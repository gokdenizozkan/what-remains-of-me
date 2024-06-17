require 'net/http'

class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update ]

  # GET /users or /users.json
  def index
    if params[:user_id]
      @user = User.find params[:user_id]
    else
      if params[:search]
        @query = params[:search]
        query = "%#{@query}%"
        @users = User.where('username ILIKE ?', query).order(:id)
      else
        @users = User.all.order(:id)
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_profile_path(@user), notice: "User was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:search, :name, :username, :email, :phone, :website, :street, :suite, :city, :zipcode, :lat, :lng, :company_name, :catch_phrase, :bs)
  end
end
