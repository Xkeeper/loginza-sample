class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    #begin
    #@user = User.new(params[:user])
    if data = Loginza.user_data(params[:token])
      @user, result = User.find_or_create(data)
      if @user
        self.current_user = @user
        new_cookie_flag = 1 #(params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
      end
    end
    #rescue
      #redirect_to users_path
      #return false
    #end

    respond_to do |format|
      if @user.save
        format.html { redirect_to :action => 'change_username', :id =>@user.id } if @user.username =~ /user\d+/ && result
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_username
    @user = current_user
    respond_to do |format|
      if @user && @user.id == params[:id].to_i
        if request.put? && @user.update_attributes(params[:user])
            format.html {redirect_to @user, notice: 'User was successfully updated.'}
        else
          format.html {}
        end
      else
        format.html {redirect_to users_path}
      end
    end

  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
end
