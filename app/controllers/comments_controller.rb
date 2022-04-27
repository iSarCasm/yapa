class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[ edit update destroy ]
  before_action :set_post, only: %i[ create ]
  before_action :authorize_user!, only: %i[ edit update destroy ]

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.post = @post

    if @comment.save
      redirect_to post_url(@comment.post), notice: "Comment was successfully created."
    else
      render 'posts/show'
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    if @comment.update(comment_params)
      redirect_to post_url(@comment.post), notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    redirect_to @comment.post, notice: "Comment was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body, :user_id, :post_id)
    end

    def authorize_user!
      raise ActionController::RoutingError, 'Not Found' unless @comment.user == current_user
    end
end
