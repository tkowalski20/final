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
  String :visitors
  Float :lat
  Float :long
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :park_id
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
                    description: "Yosemite National Park is in California’s Sierra Nevada mountains. It’s famed for its giant, ancient sequoia trees, and for Tunnel View, the iconic vista of towering Bridalveil Fall and the granite cliffs of El Capitan and Half Dome. In Yosemite Village are shops, restaurants, lodging, the Yosemite Museum and the Ansel Adams Gallery, with prints of the photographer’s renowned black-and-white landscapes of the area.",
                    date: "Open All Year",
                    location: "California",
                    visitors: "4,009,436",
                    lat: 37.8651,
                    long: -119.596848)

parks_table.insert(title: "Rocky Mountain National Park", 
                    description: "Rocky Mountain National Park in northern Colorado spans the Continental Divide and encompasses protected mountains, forests and alpine tundra. It's known for the Trail Ridge Road and the Old Fall River Road, drives that pass aspen trees and rivers. The Keyhole Route, a climb crossing vertical rock faces, leads up Longs Peak, the park’s tallest mountain. A trail surrounding Bear Lake offers views of the peaks.",
                    date: "Open All Year",
                    location: "Colorado",
                    visitors: "4,590,493",
                    lat: 40.3427932,
                    long: -105.6836389)

parks_table.insert(title: "Grand Canyon National Park", 
                    description: "Grand Canyon National Park, in Arizona, is home to much of the immense Grand Canyon, with its layered bands of red rock revealing millions of years of geological history. Viewpoints include Mather Point, Yavapai Observation Station and architect Mary Colter’s Lookout Studio and her Desert View Watchtower. Lipan Point, with wide views of the canyon and Colorado River, is a popular, especially at sunrise and sunset.",
                    date: "Open All Year",
                    location: "Arizona",
                    visitors: "‎6,380,495",
                    lat: 36.056595,
                    long: -112.125092)
