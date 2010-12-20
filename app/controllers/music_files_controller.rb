class MusicFilesController < ApplicationController
  before_filter :require_user
  before_filter :current_user_only, :except => [:index, :show]
  
  # GET users/:user_id/music_files
  # GET users/:user_id/music_files.xml
  def index
    @user = User.find_by_id(params[:user_id])
    @music_files = @user.music_files

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @music_files }
    end
  end

  # GET users/:user_id/music_files/1
  # GET users/:user_id/music_files/1.xml
  def show
    @music_file = MusicFile.find_by_user_id_and_id(params[:user_id], params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @music_file }
    end
  end

  # GET users/:user_id/music_files/new
  # GET users/:user_id/music_files/new.xml
  def new
    # Options here: 1) use current_user  2) use new and pass user_id 3) do it the formal way (look up user record)
    # If admin can add music files on behalf of user, only 2 + 3 will work. 
    @user = User.find_by_id(params[:user_id])
    @music_file = @user.music_files.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @music_file }
    end
  end

  # GET users/:user_id/music_files/1/edit
  def edit
    @user = User.find_by_id(params[:user_id])
    @music_file = @user.music_files.find_by_id(params[:id])
  end

  # POST users/:user_id/music_files
  # POST users/:user_id/music_files.xml
  def create
    @user = User.find_by_id(params[:user_id])
    # TO DO redirect with error message if @user is nil
    @music_file = @user.music_files.build(params[:music_file])
    logger.debug("@music_file is #{@music_file.inspect}")

    respond_to do |format|
      if @music_file.save
        format.html { redirect_to(@user, :notice => 'Music file metadata was successfully created.') }
        format.xml  { render :xml => @music_file, :status => :created, :location => @music_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @music_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT users/:user_id/music_files/1
  # PUT users/:user_id/music_files/1.xml
  def update
    @user = User.find_by_id(params[:user_id])
    @music_file = @user.music_files.find_by_id(params[:id])

    respond_to do |format|
      if @music_file.update_attributes(params[:music_file])
        format.html { redirect_to(@user, :notice => 'Music file metadata was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @music_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /music_files/1
  # DELETE /music_files/1.xml
  def destroy
    @music_file = MusicFile.find(params[:id])
    @music_file.destroy

    respond_to do |format|
      format.html { redirect_to(music_files_url) }
      format.xml  { head :ok }
    end
  end
  
private

  def current_user_only
    uid = params[:user_id].to_i rescue nil
    if current_user.id != uid
      flash[:notice] = "I'm sorry, #{current_user.login} - I can't do that."
      redirect_to current_user
      return false
    end
    true 
  end
  
end
