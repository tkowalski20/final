# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :parks do
  primary_key :id
  String :title
  String :description, text: true
  String :date
  String :location
end
DB.create_table! :rsvps do
  primary_key :id
  foreign_key :event_id
  foreign_key :user_id
  Boolean :going
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
parks_table = DB.from(:parks)

parks_table.insert(title: "Yosemite National Park", 
                    description: "Here we go again bacon burger taco fans, another Bacon Burger Taco Fest is here!",
                    date: "June 21",
                    location: "Kellogg Global Hub")

parks_table.insert(title: "Rocky Mountain National Park", 
                    description: "If you're into nutrition and vitamins and stuff, this is the event for you.",
                    date: "July 4",
                    location: "Nowhere")

parks_table.insert(title: "Grand Canyon National Park", 
                    description: "If you're into nutrition and vitamins and stuff, this is the event for you.",
                    date: "July 4",
                    location: "Nowhere")
