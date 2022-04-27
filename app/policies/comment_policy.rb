class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
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
    comment_author?
  end

  def destroy?
    comment_author? || post_author?
  end

  private

  def comment_author?
    comment.user == user
  end

  def post_author?
    comment.post.user == user
  end
end