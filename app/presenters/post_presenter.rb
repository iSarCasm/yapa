class PostPresenter
  attr_reader :post, :comments_page, :new_comment

  delegate :title, :body, :user, :created_at, to: :post

  def initialize(post:, new_comment: nil, comments_page: nil)
    @post = post
    @comments_page = comments_page
    @new_comment = new_comment || @post.comments.new
  end

  def comments
    comments = @post.comments.order(created_at: :asc).page
    @comments ||=
      if comments_page
        comments.page(comments_page)
      else
        last_page = comments.total_pages
        comments.page(last_page)
      end
  end
end