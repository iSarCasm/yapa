require 'rails_helper'

describe 'Comments', type: :feature do
  let(:user) { create(:user) }
  let(:post) { create(:post, title: 'Test Title') }

  before do
    sign_in user
  end

  it 'can be created from the post page' do
    visit post_path(post)
    fill_in 'comment_body', with: 'Test Body'
    click_button 'Submit'

    expect(page).to have_content 'Test Body'
  end

  it 'can see a list of all comments' do
    create(:comment, body: 'Test Comment', post: post)
    create(:comment, body: 'Test Comment 2', post: post)

    visit post_path(post)

    expect(page).to have_content 'Test Comment'
    expect(page).to have_content 'Test Comment 2'
  end

  context 'as owner of the comment' do
    let!(:comment) { create(:comment, body: 'Test Comment', post: post, user: user) }

    it 'can destroy a comment' do
      visit post_path(post)
      click_link 'Destroy'

      expect(page).to have_current_path(post_path(post))
      expect(page).to have_content 'Comment was successfully destroyed'
      expect(page).not_to have_content 'Test Comment'
    end

    it 'can edit a comment' do
      visit post_path(post)
      click_link 'Edit'
      fill_in 'comment_body', with: 'Test Comment Edited'
      click_button 'Submit'

      expect(page).to have_current_path(post_path(post))
      expect(page).to have_content 'Comment was successfully updated'
      expect(page).to have_content 'Test Comment Edited'
    end
  end

  context 'as not owner of the comment' do
    let!(:comment) { create(:comment, body: 'Test Comment', post: post) }

    it 'cannot destroy or edit a comment' do
      visit post_path(post)

      expect(page).not_to have_link 'Destroy'
      expect(page).not_to have_link 'Edit'
    end
  end
end