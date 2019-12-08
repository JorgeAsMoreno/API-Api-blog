require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET / posts" do
    before { get '/posts' }

    it "Should return OK" do
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  end

  describe "With data in db" do
    let!(:posts) { create_list(:post, 10, published: true)}

    it "Should return all the published posts" do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)      
    end
  end

  describe "GET /post/{id}" do
    let!(:post) { create(:post)}
    it "Should return a posts" do
      get "/posts/#{post.id}"      
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(post.id)
      expect(response).to have_http_status(200)      
      end
    end

  describe "POST /post" do
    let!(:user) { create(:user) }
    it "Should create a post" do
      req_payload = {
        post: {
        title: "title",
        content: "content",
        published: false,
        user_id: user.id
      }
    }

      post "/posts", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to_not be_nil
      expect(response). to have_http_status(:created)
    end

    it "Should return error mesage on invalid post" do
      req_payload = {
        post: {
        content: "content",
        published: false,
        user_id: user.id
      }
    }

    post "/posts", params: req_payload
    payload = JSON.parse(response.body)
    expect(payload).to_not be_empty
    expect(payload["error"]).to_not be_empty
    expect(response). to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /post/{id}" do
    let!(:article) { create(:post) }
    it "Should create a post" do
      req_payload = {
        post: {
        title: "title",
        content: "content",
        published: false,
      }
    }

    put "/posts/#{article.id}", params: req_payload
    payload = JSON.parse(response.body)
    expect(payload).to_not be_empty
    expect(payload["id"]).to eq(article.id)
    expect(response). to have_http_status(:ok )
    end

    it "Should return error mesage on invalid post" do
      req_payload = {
        post: {
        title: nil,
        content: nil,
        published: false,
      }
    }

    put "/posts/#{article.id}", params: req_payload
    payload = JSON.parse(response.body)
    expect(payload).to_not be_empty
    expect(payload["error"]).to_not be_empty
    expect(response). to have_http_status(:unprocessable_entity)
    end
  end
end