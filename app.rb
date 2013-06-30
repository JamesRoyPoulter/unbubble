require "sinatra"
require "sinatra/reloader"
require "pg"
require "haml"

configure do
  enable :sessions
end

before do
	@db ||= PG.connect(dbname: "fastbook")
end

after do
  @db.close
end

get "/" do
	@friends = @db.exec "SELECT * FROM friends"
	haml :index
end

get "/mate/:id" do
  sql = "SELECT * FROM friends WHERE id=#{params[:id].to_i}"
  @mate = @db.exec(sql).first
  haml :mate
end

post "/mate/:id" do
  sql = "UPDATE friends SET name='#{params[:name]}' WHERE id=#{params[:id]}"
  @db.exec(sql)
  redirect "/mate/#{params[:id]}"
end
