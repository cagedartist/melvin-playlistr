class UsersController < ApplicationController
  before_filter :require_user, :except => [:new, :create]
  # GET /users
  # GET /users.xml
  def index
    @users = User.all(:include => :music_files)
    @friend_ids = current_user.friend_ids

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    # potential efficiency improvement: look up current_user.ratings (all ratings or only ratings for @user.music_files)
    # (currently, there is a separate query in the view for current_user's rating of each of @user.music_files) 

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'Your account was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'Your account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # kind of a hack to make this a GET, but it's getting very late...
  def friend
    # make sure user exists
    user = User.find(params[:id])
    ul = current_user.user_links.create(:linked_user_id => user.id) if user
    redirect_to users_path, :notice => (ul.blank? ? 'There was a problem adding the friend.' : 'Friend was added successfully.')
  end
  
  def unfriend
    ul = current_user.user_links.find_by_linked_user_id(params[:id])
    ul.destroy if ul
    redirect_to users_path, :notice => 'Friend was removed successfully.'
  end
  
  def playlist
    # randomly sorted top 20 in-network music files
    @playlist = current_user.top_20.sort_by{rand}
  end
  
end
