require 'net/http'

class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]

  # GET /users or /users.json
  def index
    if params[:search]&.present?
      query = "%#{params[:search]}%"
      @users = User.where('username ILIKE ?', query).order(:id)
    else
      @users = User.all.order(:id)
    end
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def fetch_image_url_of_user(user_id)
    get("https://picsum.photos/id/#{user_id}/info")['download_url']
  end
  helper_method :fetch_image_url_of_user

  def fetch_album_titles_of_user(user_id)
    fetch 'https://jsonplaceholder.typicode.com/albums', 'userId', user_id, 'title'
  end
  helper_method :fetch_album_titles_of_user

  def fetch_photo_urls_of_album(album_id)
    fetch 'https://jsonplaceholder.typicode.com/photos', 'albumId', album_id, 'url'
  end
  helper_method :fetch_photo_urls_of_album

  def fetch_photo_thumbnail_urls_of_album(album_id)
    fetch 'https://jsonplaceholder.typicode.com/photos', 'albumId', album_id, 'thumbnailUrl'
  end
  helper_method :fetch_photo_thumbnail_urls_of_album

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:search, :name, :username, :email, :phone, :website, :street, :suite, :city, :zipcode, :lat, :lng, :company_name, :catch_phrase, :bs)
  end

  def get(url)
    uri = URI.parse url
    request = Net::HTTP::Get.new uri.to_s
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http|
      http.request request
    }
    JSON.parse response.body
  end

  def fetch(target_url, lookup_name, lookup_id, resource_name)
    resources = get(target_url)

    desireds = []
    resources.each do |resource|
      next unless resource[lookup_name] == lookup_id
      desireds << resource[resource_name]
    end
    desireds
  end
end
