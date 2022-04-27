require 'rails_helper'

describe "/posts/show.html.erb" do
  let(:post) { create :post }
  let(:post_presenter) do
    instance_double(
      PostPresenter,
      post: post,
      title: 'Impressions of the Day',
      body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      created_at: 2.days.ago,
      author: 'John Doe',
      comments: Kaminari.paginate_array([]).page(1),
    )
  end

  before do
    assign(:post_presenter, post_presenter)
    without_partial_double_verification do
      allow(view).to receive(:policy).and_return(instance_double(PostPolicy, edit?: true, destroy?: true))
    end
  end

  it 'renders Author name' do
    render
    expect(rendered).to match('John Doe')
  end

  it 'renders Title' do
    render
    expect(rendered).to match('Impressions of the Day')
  end

  it 'renders Body' do
    render
    expect(rendered).to match('Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
  end

  it 'renders Created at' do
    render
    expect(rendered).to match(/Posted 2 days ago/)
  end

  it 'renders comment section' do
    render

    expect(rendered).to match('Comments')
    expect(rendered).to match('No comments yet')
  end
end