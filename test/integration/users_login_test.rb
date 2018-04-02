require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:morna)
  end
  
  test "login with invalid information" do
    # Verify the login path
    get login_path
    # Verify the new session renders properly
    assert_template 'sessions/new'
    # Post to the sessions params hash
    post login_path, params: { session: { email: "", password: "" } }
    # Verify that new sessions form gets re-rendered and that a flash message appears
    assert_template 'sessions/new'
    assert_not flash.empty?
    # Visit another page
    get root_path
    # Verify that the flash maessage doesn't appear on the new view page
    assert flash.empty?
  end


  test "login with valid information" do
    # Visit the login path.
    get login_path
    # Post valid information to the sessions path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'} }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # Verify that the login link disappears.
    assert_select "a[href=?]", login_path, count: 0
    # Verify that a logout link appears
    assert_select "a[href=?]", logout_path
    # Verify that a profile link appears.
    assert_select "a[href=?]", user_path(@user)
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
end