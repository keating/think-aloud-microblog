class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def index
    @user = User.find_by_id(params[:user_id])
    flash[:fail] = "There isn't a user'" if @user.nil?
    @microposts = @user.microposts.paginate(:page => params[:page]) unless @user.nil?
  end

  def create
    puts "=================#{request.url} #{request.url.ends_with?("hello_world")}"
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      if params[:hello_world_page]
        redirect_to "/hello_world"
      else
        redirect_to root_path
      end
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end

end