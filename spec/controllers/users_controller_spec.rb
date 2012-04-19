require 'spec_helper'
require "will_paginate"

describe UsersController do
  render_views

  # get new
  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector(:title, :content => "Sign up")
    end

    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have a email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end

    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end

    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
  end

  # get show
  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

    it "should show the user's microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      mp2 = Factory(:micropost, :user => @user, :content => "Baz quux")
      get :show, :id => @user
      response.should have_selector("div.content", :content => mp1.content)
      response.should have_selector("div.content", :content => mp2.content)
    end

    it "should have delete links" do
      test_sign_in @user
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      get :show, :id => @user
      response.should have_selector("a", "data-method" => "delete", :content => "delete")
    end

    it "should not have delete links" do
      test_sign_in Factory(:user, :email => Factory.next(:email))
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      get :show, :id => @user
      response.should_not have_selector("a", "data-method" => "delete", :content => "delete")
    end
  end

  # post create
  describe "POST 'create'" do

    # create failure
    describe "failure" do

      before(:each) do
        @attr = {:name => "", :email => "", :password => "",
                 :password_confirmation => ""}
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    # create success
    describe "success" do

      before(:each) do
        @attr = {:name => "New User", :email => "user@example.com",
                 :password => "foobar", :password_confirmation => "foobar"}
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

  # get edit
  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                    :content => "change")
    end
  end

  # put update
  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    # update failure
    describe "failure" do

      before(:each) do
        @attr = {:email => "", :name => "", :password => "",
                 :password_confirmation => ""}
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end

    # update success
    describe "success" do

      before(:each) do
        @attr = {:name => "New name", :email => "user@example.org",
                 :password => "barbaz", :password_confirmation => "barbaz"}
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  # authentication of edit/update pages
  # 这是测试过滤器的
  describe "authentication of edit/update pages" do

    before(:each) do
      @user = Factory(:user)
    end

    # non-signed-in users
    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    # signed-in users
    describe "for signed-in users" do

      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end

  # test index
  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny assces" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = test_sign_in(Factory(:user))

        second = Factory(:user, :email => "another@example.com")
        third = Factory(:user, :email => "another@example.net")
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :name => Factory.next(:name),
                            :email => Factory.next(:email))
        end
      end

      it "should be success" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                      :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                      :content => "Next")
      end

      #普通登录用户访问用户列表首页，不能看到删除用户链接
      describe "as a non-admin user" do
        it "should not exist delete links" do
          get :index
          response.should_not have_selector("a", "data-method" => "delete", :content => "delete")
        end
      end

      #管理员登录
      describe "as a admin user" do

        before(:each) do
          admin = Factory(:user, :email => "admin@example.com", :admin => true)
          test_sign_in admin
        end

        it "should exist delete links" do
          get :index
          response.should have_selector("a", "data-method" => "delete", :content => "delete")
        end
      end
    end
  end

  #DELETE destroy
  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end

      it "should not delete the admin itself" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count)
      end

      it "should redirect to users path" do
        delete :destroy, :id => @admin
        response.should redirect_to(users_path)
      end
    end
  end

  #
  describe "follow pages" do

    describe "when not signed in" do

      it "should project following page" do
        get :following, :id => 1
        response.should redirect_to(signin_path)
      end

      it "sould project 'followers'" do
        get :followers, :id => 1
        response.should redirect_to(signin_path)
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = test_sign_in Factory(:user)
        @other_user = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@other_user)
      end

      it "should show user following" do
        get :following, :id => @user
        response.should have_selector('a', :href => user_path(@other_user),
                                      :content => @other_user.name)
      end

      it "should show user followers" do
        get :followers, :id => @other_user
        response.should have_selector('a', :href => user_path(@user),
                                      :content => @user.name)
      end
    end
  end

  # get 'show' for status
  describe "get 'show' for status" do

    before(:each) do
      @user = Factory(:user, :name => "andy")
      test_sign_in(@user)
      13.times { Factory(:micropost, :user => @user) }
    end

    it "should have name on the status page" do
      get 'show', :id => @user
      response.should have_selector("strong", :content => "Name")
      response.should have_selector("a", :href => user_path(@user), :content => user_path(@user));
      response.should have_selector("label", :content => "13")
    end
  end
end