class PostPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    !user.nil?
  end

  def update?
    post_author?
  end

  def destroy?
    post_author?
  end

  private

  def post_author?
    post.user == user
  end
end