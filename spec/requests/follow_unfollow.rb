require 'spec_helper'

describe "follow" do

  before(:each) do
    @user = Factory(:user)
    @followed =  Factory(:user, :email => Factory.next(:email))
    intergration_sign_in(@user)
  end

  it "should have a follow button and can follow" do
    lambda do
      visit user_path(@followed)
      click_button('Follow')
      response.should have_selector("input[value='UnFollow']")
      @user.following.should include(@followed)
    end.should change(Relationship, :count).by(1)
  end

  it "should have a unfollow button and can unfollow" do
    @user.follow!(@followed)
    lambda do
      visit user_path(@followed)
      click_button('UnFollow')
      response.should have_selector("input[value='Follow']")
      @user.following.should_not include(@followed)
    end.should change(Relationship, :count).by(-1)
  end

end