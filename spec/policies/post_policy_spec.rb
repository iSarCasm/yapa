require 'rails_helper'

describe 'PostPolocy' do
  it 'index? returns true' do
    expect(PostPolicy.new(nil, nil).index?).to eq(true)
  end

  it 'show? returns true' do
    expect(PostPolicy.new(nil, nil).show?).to eq(true)
  end

  describe 'create?' do
    it 'returns true if user is not nil' do
      expect(PostPolicy.new(User.new, nil).create?).to eq(true)
    end

    it 'returns false if user is nil' do
      expect(PostPolicy.new(nil, nil).create?).to eq(false)
    end
  end

  describe 'update?' do
    it 'returns true if user is the post author' do
      post = create :post
      expect(PostPolicy.new(post.user, post).update?).to eq(true)
    end

    it 'returns false if user is not the post author' do
      post = create :post
      expect(PostPolicy.new(User.new, post).update?).to eq(false)
    end
  end

  describe 'destroy?' do
    it 'returns true if user is the post author' do
      post = create :post
      expect(PostPolicy.new(post.user, post).destroy?).to eq(true)
    end

    it 'returns false if user is not the post author' do
      post = create :post
      expect(PostPolicy.new(User.new, post).destroy?).to eq(false)
    end
  end
end