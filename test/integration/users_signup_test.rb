require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	  test "invalid signup information" do
	    get signup_path
	    assert_no_difference 'User.count' do
	      post users_path, params: { user: { name:  "",
	                                         email: "user@invalid",
	                                         password:              "foo",
	                                         password_confirmation: "bar" } }
	    end
	    assert_template 'users/new'
			assert_select 'div#error_explanation'
	    assert_select 'div.field_with_errors'
			assert_select 'ul' do
				assert_select 'li', 'Email is invalid'
				assert_select 'li', 'Password confirmation doesn\'t match Password'
				assert_select 'li', 'Password is too short (minimum is 6 characters)'
			end
	  end

		test "valid signup information" do
			get signup_path
			assert_difference 'User.count', 1 do
				post users_path, params: { user: { name:  "Example User",
																					 email: "user@example.com",
																					 password:              "password",
																					 password_confirmation: "password" } }
			end
			follow_redirect!
			assert_template 'users/show'
			assert is_logged_in?
			assert_not flash.empty?
		end

		# テストユーザーがログイン中の場合にtrueを返す
		def is_logged_in?
			!session[:user_id].nil?
		end

		# テストユーザーとしてログインする
		def log_in_as(user)
			session[:user_id] = user.id
		end


end
