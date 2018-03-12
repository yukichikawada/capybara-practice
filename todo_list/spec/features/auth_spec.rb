require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do
  before :each do
    visit new_user_path
  end

  scenario 'has a new user page' do
    expect(page).to have_content('Sign Up')
  end

  feature 'signing up a user' do
    scenario 'shows username on the homepage after signup' do
      fill_in 'Username', with: 'jack'
      fill_in 'Password', with: 'abcdef'
      click_button 'Sign Up'
      expect(page).to have_content('jack')
    end

  end
end

feature 'logging in' do
  # before :each do
  #   visit new_session_path
  # end


  scenario 'shows username on the homepage after login' do
    visit new_user_path
    fill_in 'Username', with: 'jack'
    fill_in 'Password', with: 'abcdef'
    click_button 'Sign Up'
    click_button 'Sign Out'
    fill_in 'Username', with: 'jack'
    fill_in 'Password', with: 'abcdef'

    click_button 'Sign In'

    expect(page).to have_content('jack')
  end

end

feature 'logging out' do
  before :each do
    visit new_user_path
  end

  scenario 'begins with a logged out state' do
    expect(page).to have_content('Sign Up')
    expect(page).to have_content('Sign In')
  end

  scenario 'doesn\'t show username on the homepage after logout' do
    fill_in 'Username', with: 'jack'
    fill_in 'Password', with: 'abcdef'
    click_button 'Sign Up'
    click_button 'Sign Out'
    expect(page).to_not have_content('jack')
  end

end
