require "sinatra"
require "sinatra/reloader"
require "pg"
require "haml"

configure do
  enable :sessions
end

before do
	@db ||= PG.connect(dbname: "unbubble")
end

after do
  @db.close
end


# Homepage - list of blog posts
get "/" do
	@posts = @db.exec "SELECT * FROM unbubble"
	haml :index
end


# New - go to page that creates new blog
get '/new' do
  haml :new
end


# Create - create new blog and send to database
post '/create' do
  title = params[:title]
  content = params[:content]
  creation_date = params[:creation_date]
  sql = "insert into unbubble (title, content, creation_date) values ('#{title}', '#{content}', '#{creation_date}')"
  @db.exec(sql)
  redirect to('/')
end


# Show - go to page showing blog, and form for update
get "/posts/:id" do
  sql = "SELECT * FROM unbubble WHERE id=#{params[:id].to_i}"
  @title = @db.exec(sql).first
  haml :post
end


# Update - when submit form this updates the blog post
post "/posts/:id" do
  sql = "UPDATE unbubble SET title='#{params[:title]}', content='#{params[:content]}', creation_date='#{params[:creation_date]}' WHERE id=#{params[:id]}"
  @db.exec(sql)
  redirect "/posts/#{params[:id]}"
end


# Delete - delete a post
get '/delete/:id' do
  sql = "delete from unbubble where id = #{params[:id]}"
  @db.exec(sql)
  redirect to('/')
end
