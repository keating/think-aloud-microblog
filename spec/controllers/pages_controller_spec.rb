require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end    
    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
		:content => @base_title+"Home")
    end

    #练习题，测试登录用户首页右侧的post数量
    describe "micropost count" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in @user
      end

      it "should have micropost span" do
        get :home
        response.should have_selector("span.microposts")
      end

      it "should have 1 micropost" do
        Factory(:micropost, :user => @user, :content => "this is a micropost")
        get :home
        response.should have_selector("span.microposts", :content => "1 micropost")
      end

      it "should have 50 microposts" do
        50.times { Factory(:micropost, :user => @user, :content => "micropost content") }
        get :home
        response.should have_selector("span.microposts", :content => "50 microposts")
      end

      it "should paginate microposts" do
        50.times { Factory(:micropost, :user => @user, :content => "micropost content") }
        get :home
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2",
                                      :content => "2")
        response.should have_selector("a", :href => "/?page=2",
                                      :content => "Next")
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
		:content => @base_title+"Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_successful
    end
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
		:content => @base_title+"About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_successful
    end
    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
		:content => @base_title+"Help")
    end
  end

end
