# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"  
require "sinatra/cookies"                                                             #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "geocoder"                                                                    #
require "logger"                                                                      #
require "bcrypt"                                                                      #
require "twilio-ruby"                                                                 #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

parks_table = DB.from(:parks)
rsvps_table = DB.from(:rsvps)
users_table = DB.from(:users)

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

get "/" do
    puts parks_table.all
    @parks = parks_table.all.to_a
    view "parks"
end

get "/parks/:id" do
    @park = parks_table.where(id: params[:id]).to_a[0]
    @rsvps = rsvps_table.where(event_id: @park[:id])
    @going_count = rsvps_table.where(event_id: @park[:id], going: true).count
    @users_table = users_table
    @lat = 37.8651
    @long = -119.596848
    view "park"
end

get "/parks/:id/rsvps/new" do
    @park = parks_table.where(id: params[:id]).to_a[0]
    view "new_rsvp"
end

get "/parks/:id/rsvps/create" do
    puts params
    @park = parks_table.where(id: params["id"]).to_a[0]
    rsvps_table.insert(event_id: params["id"],
                       user_id: session["user_id"],
                       going: params["going"],
                       comments: params["comments"])
    view "create_rsvp"
end

get "/users/new" do
    view "new_user"
end

post "/users/create" do
    puts params
    hashed_password = BCrypt::Password.create(params["password"])
    users_table.insert(name: params["name"], email: params["email"], password: hashed_password)
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    user = users_table.where(email: params["email"]).to_a[0]
    puts BCrypt::Password::new(user[:password])
    if user && BCrypt::Password::new(user[:password]) == params["password"]
        session["user_id"] = user[:id]
        @current_user = user
        view "create_login"
    else
        view "create_login_failed"
    end
end

get "/logout" do
    session["user_id"] = nil
    @current_user = nil
    view "logout"
end