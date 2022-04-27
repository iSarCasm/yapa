require 'rails_helper'

describe 'Users', type: :feature do
  it 'can sign up' do
    visit '/'
    click_button 'Sign Up'
    fill_in 'Email', with: 'john@doe.com'
    fill_in 'Name', with: 'John Doe'
    fill_in 'Password', with: '123123'
    fill_in 'Password confirmation', with: '123123'
    click_button 'Submit'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_content 'John Doe'
    expect(page).to have_button 'Sign Out'
  end

  it 'can sign-in' do
    user = create(:user)

    visit '/'
    click_button 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Submit'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content user.name
    expect(page).to have_button 'Sign Out'
  end

  it 'can sign-out' do
    user = create(:user)
    sign_in user

    visit '/'
    click_button 'Sign Out'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_button 'Sign In'
  end

  it 'can edit their profile' do
    user = create(:user)
    sign_in user

    visit '/'
    click_link user.name
    fill_in 'Name', with: 'John Doe'
    fill_in 'Email', with: 'newmail@mail.com'
    fill_in 'Password', with: '123123'
    fill_in 'Password confirmation', with: '123123'
    fill_in 'Current password', with: user.password
    click_button 'Update'

    expect(page).to have_current_path '/'
    expect(page).to have_content 'Your account has been updated successfully.'
    expect(page).to have_link 'John Doe'
  end
end