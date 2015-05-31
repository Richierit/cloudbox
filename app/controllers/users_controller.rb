class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :conns3
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if current_user.folder.nil?
      current_user.folder = generate_random_user_user_folder_name
      current_user.save
    end
    userfile = Userfile.all
    @files = userfile.where(user_id: current_user.id)
    @permission_recieved = Permission.where(sharedto: current_user.email)
    @permission_given = Permission.where(sharer: current_user.email)
  end

  def conns3
    @bucket_name = 'mymegaawesomedropbox'
    @s3 = Aws::S3::Client.new
    @s3r = Aws::S3::Resource.new
    @user_bucket_resource = @s3r.bucket(@bucket_name)
    @user_objects = @s3.list_objects(bucket: @bucket_name, prefix: current_user.folder).contents
    if user_signed_in?
      user_object_name
    end
  end

  def generate_random_user_user_folder_name()
    letters = [('a'..'z'),('A'..'Z')].map { |i| i.to_a }.flatten
    return (0..8).map{ letters[rand(letters.length)] }.join
  end

  def user_object_name
    object_name_list = []
    i = 0
    @user_objects.each_with_index do |obj, index|
      key = obj.key
      size = obj.size
      object_name_list.insert(index, key)
    end
    object_data(object_name_list)
  end

  def object_data(object_name_list)
    @total_size = 0
    @total_size = cal_totalsize(@objects)
    @total_size = cal_byte(@total_size)
    @object_type = []
    @object_link = []
    @object_size = []
    object_name_list.each_with_index do |name, index|
      @object_type.insert(index, @user_bucket_resource.object(name).content_type)
      @object_link.insert(index, @user_bucket_resource.object(name).public_url)
      @object_size.insert(index, cal_byte(@user_bucket_resource.object(name).content_length))
    end
    store_file(@object_link, @object_size)
  end
  def store_file(link, size)
    if @user_objects.blank?   
        @user_objects.each_with_index do |object, index|
        key = object.key
        key.slice! current_user.folder+"/"
        @userfile = Userfile.new(name: key, link: link[index], size: size[index])
        @userfile.user_id = current_user.id
        @userfile.save
      end
    else
    end
  end

  def cal_totalsize(objects)
    total_size = 0
    @user_objects.each do |object|
      total_size = total_size + object.size
    end
    return total_size
  end
  
  def cal_byte(size)
    kb = 1024.00
    mb = kb * 1024.00
    if size < mb then
      if size < kb then 
        size = size.round(2)
        return "#{size} byte"
      else
        size = size / kb
        size = size.round(2)
        return "#{size} kb"
      end
    else
      size = size / mb
      size = size.round(2)
      return "#{size} mb"
    end
  end


  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
