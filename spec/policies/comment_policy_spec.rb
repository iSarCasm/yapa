require 'rails_helper'

describe 'CommentPolicy' do
  it 'index? returns true' do
    expect(CommentPolicy.new(nil, nil).index?).to eq(true)
  end

  it 'show? returns true' do
    expect(CommentPolicy.new(nil, nil).show?).to eq(true)
  end

  describe 'create?' do
    it 'returns true if user is not nil' do
      expect(CommentPolicy.new(User.new, nil).create?).to eq(true)
    end

    it 'returns false if user is nil' do
      expect(CommentPolicy.new(nil, nil).create?).to eq(false)
    end
  end

  describe 'update?' do
    it 'returns true if user is the comment author' do
      comment = create :comment
      expect(CommentPolicy.new(comment.user, comment).update?).to eq(true)
    end

    it 'returns false if user is not the comment author' do
      comment = create :comment
      expect(CommentPolicy.new(User.new, comment).update?).to eq(false)
    end
  end

  describe 'destroy?' do
    it 'returns true if user is the comment author' do
      comment = create :comment
      expect(CommentPolicy.new(comment.user, comment).destroy?).to eq(true)
    end

    it 'returns true if user is the post author' do
      comment = create :comment
      expect(CommentPolicy.new(comment.post.user, comment).destroy?).to eq(true)
    end

    it 'returns false if user is not the comment author' do
      comment = create :comment
      expect(CommentPolicy.new(User.new, comment).destroy?).to eq(false)
    end
  end
end