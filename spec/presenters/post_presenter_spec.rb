require 'rails_helper'

describe 'PostPresenter' do
  it 'delegates title to post' do
    post = build :post
    presenter = PostPresenter.new post: post
    expect(presenter.title).to eq(post.title)
  end

  it 'delegates body to post' do
    post = build :post
    presenter = PostPresenter.new post: post
    expect(presenter.body).to eq(post.body)
  end

  it 'delegates created_at to post' do
    post = build :post
    presenter = PostPresenter.new post: post
    expect(presenter.created_at).to eq(post.created_at)
  end

  it '#author returns post author name' do
    post = build :post
    presenter = PostPresenter.new post: post
    expect(presenter.author).to eq(post.user.name)
  end

  describe '#new_comment' do
    it 'returns a new comment if new_comment is nil' do
      post = build :post
      presenter = PostPresenter.new post: post
      expect(presenter.new_comment).to be_a(Comment)
    end

    it 'returns new_comment if new_comment is not nil' do
      post = build :post
      comment = build :comment
      presenter = PostPresenter.new post: post, new_comment: comment
      expect(presenter.new_comment).to eq(comment)
    end
  end

  describe '#comments' do
    it 'returns comments ordered by created_at' do
      post = create :post
      comment1 = create :comment, post: post
      comment2 = create :comment, post: post
      presenter = PostPresenter.new post: post
      expect(presenter.comments).to eq([comment1, comment2])
    end

    it 'paginates comments 10 per page' do
      post = create :post
      comments = create_list :comment, 20, post: post
      presenter = PostPresenter.new post: post

      expect(presenter.comments.size).to eq 10
    end

    it 'paginates to last page if comments_page is nil' do
      post = create :post
      comments = create_list :comment, 15, post: post
      presenter = PostPresenter.new post: post

      expect(presenter.comments.current_page).to eq 2
    end

    it 'paginates to comments_page if it is not nil' do
      post = create :post
      comments = create_list :comment, 15, post: post
      presenter = PostPresenter.new post: post, comments_page: 1

      expect(presenter.comments.current_page).to eq 1
    end
  end
end