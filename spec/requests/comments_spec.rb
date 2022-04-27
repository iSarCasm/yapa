require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let(:user) { create :user }
  let(:user_post) { create :post, user: user }
  let(:comment) { create :comment, post: user_post, user: user }

  let(:valid_attributes) {
    {
      body: "MyText long text",
    }
  }

  let(:invalid_attributes) {
    {
      body: '',
    }
  }

  before { sign_in user }

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_post_comment_url(user_post, comment)
      expect(response).to be_successful
    end

    it 'redeirects when unauthenticated' do
      sign_out user
      get edit_post_comment_url(user_post, comment)
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'returns error when unauthorized' do
      comment = create :comment
      expect { get edit_post_comment_url(comment.post, comment) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Comment" do
        expect {
          post post_comments_url(user_post), params: { comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it "redirects to the current post" do
        post post_comments_url(user_post), params: { comment: valid_attributes }
        expect(response).to redirect_to(post_url(user_post))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Comment" do
        expect {
          post post_comments_url(user_post), params: { comment: invalid_attributes }
        }.to change(Comment, :count).by(0)
      end

      it "renders a success response" do
        post post_comments_url(user_post), params: { comment: invalid_attributes }
        expect(response.status).to eq(200)
      end
    end

    it 'redirects when unauthenticated' do
      sign_out user
      post post_comments_url(user_post), params: { comment: valid_attributes }
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          body: "MyText long text2",
        }
      }

      it "updates the requested comment" do
        patch post_comment_url(user_post, comment), params: { comment: new_attributes }
        comment.reload
        expect(comment.body).to eq "MyText long text2"
      end

      it "redirects to the comment" do
        patch post_comment_url(user_post, comment), params: { comment: new_attributes }
        comment.reload
        expect(response).to redirect_to(post_url(user_post))
      end
    end

    context "with invalid parameters" do
      it "renders a 422 response" do
        patch post_comment_url(user_post, comment), params: { comment: invalid_attributes }
        expect(response.status).to eq 422
      end
    end

    it 'redirects when unauthenticated' do
      sign_out user
      patch post_comment_url(user_post, comment)
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'returns error when unauthorized' do
      comment = create :comment
      expect { patch post_comment_url(comment.post, comment) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested comment" do
      new_comment = create :comment, post: user_post, user: user
      expect {
        delete post_comment_url(user_post, new_comment)
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      delete post_comment_url(user_post, comment)
      expect(response).to redirect_to(post_url(user_post))
    end

    it 'redirects when unauthenticated' do
      sign_out user
      delete post_comment_url(user_post, comment)
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'returns error when unauthorized' do
      comment = create :comment
      expect { delete post_comment_url(comment.post, comment) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end
