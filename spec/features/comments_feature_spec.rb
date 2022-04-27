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

  it 'can see a list of all comments oldest first' do
    create(:comment, body: 'Test Comment', post: post)
    create(:comment, body: 'Test Comment 2', post: post)

    visit post_path(post)

    comments = find_all('div[data-test="comment"] .card-text')
    expect(comments.map(&:text)).to eq(['Test Comment', 'Test Comment 2'])
  end

  it 'can paginate a list of comments' do
    create_list(:comment, 15, post: post)
    latest_comment = create :comment, body: 'Control Comment', post: post

    visit post_path(post)

    expect(page).to have_content 'Control Comment'

    click_link 'Prev'

    expect(page).to have_no_content 'Control Comment'

    click_link 'Next'

    expect(page).to have_content 'Control Comment'
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