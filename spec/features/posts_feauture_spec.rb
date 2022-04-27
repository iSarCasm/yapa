require 'rails_helper'

describe 'Posts', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  it 'can be created from the homepage' do
    visit '/'
    click_button 'New Post'
    fill_in 'Title', with: 'Test Title'
    fill_in 'Body', with: 'Test Body 10 char min'
    click_button 'Submit'

    expect(page).to have_content 'Test Title'
  end

  it 'can see a list of all posts' do
    create(:post, title: 'Test Title')
    create(:post, title: 'Test Title 2')

    visit '/'

    expect(page).to have_content 'Test Title'
    expect(page).to have_content 'Test Title 2'
  end

  it 'can see a post' do
    post = create(:post, title: 'Test Title', body: 'Test Body extra long')

    visit '/'
    click_link 'Test Title'

    expect(page).to have_current_path(post_path(post))
    expect(page).to have_content 'Test Title'
    expect(page).to have_content 'Test Body extra long'
  end

  context 'as owner of the post' do
    let!(:post) { create(:post, title: 'Test Title', user: user) }

    it 'can edit a post' do
      visit post_path(post)
      click_link 'Edit'
      fill_in 'Title', with: 'Test Title Edited'
      fill_in 'Body', with: 'Test Body Edited'
      click_button 'Submit'

      expect(page).to have_current_path(post_path(post))
      expect(page).to have_content 'Post was successfully updated'
      expect(page).to have_content 'Test Title Edited'
      expect(page).to have_content 'Test Body Edited'
    end

    it 'can destroy a post' do
      visit '/'
      click_link 'Test Title'
      click_link 'Destroy'

      expect(page).to have_current_path(posts_path)
      expect(page).to have_content 'Post was successfully destroyed'
    end
  end

  context 'as not owner of the post' do
    let!(:post) { create(:post, title: 'Test Title') }

    it 'cannot edit or destroy a post' do
      visit post_path(post)

      expect(page).to have_current_path(post_path(post))
      expect(page).to have_content 'Test Title'
      expect(page).not_to have_content 'Edit'
      expect(page).not_to have_content 'Destroy'
    end
  end
end