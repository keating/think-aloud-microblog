require 'spec_helper'

describe "Microposts" do

  before(:each) do
    user = Factory(:user) # Factory(:user) 存入了DB，然后下面访问的是登录页面
    visit signin_path
    fill_in :email,     :with => user.email
    fill_in :password,  :with => user.password
    click_button
  end

  describe "creation" do

    describe "failure" do
       it "should not make a new micropost" do
         lambda do
           visit root_path
           fill_in :micropost_content,:with => ""
           click_button
           response.should render_template('pages/home')
           response.should have_selector("div#error_explanation")
         end.should_not change(Micropost, :count)
       end
    end

    describe "success" do
      content = "Lorem ipsum dolor sit amet"
      it "should make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("div.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
end
