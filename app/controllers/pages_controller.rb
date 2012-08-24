class PagesController < ApplicationController

  layout :resolve_layout

  def home
    @title = "Home Really"
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

  def hello_world
    @title = "hello world"
    if signed_in?
      @micropost = Micropost.new
    end
  end

  private
    def resolve_layout
      case action_name
        when "hello_world"
          "blank_template"
        else
          "application"
      end
    end

end
