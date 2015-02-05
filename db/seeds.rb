# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'

Medium.delete_all
Product.delete_all
Category.delete_all
LaunchDate.delete_all
Region.delete_all
Release.delete_all

categories = {
                Games:  ['Xbox One', 'Xbox 360', 'Xbox', 
                        'PlayStation 4', 'PlayStation 3', 'PlayStation 2', 'PlayStation', 'PS Vita',
                        'Wii U', 'Wii', 'GameCube', 'Nintendo 64', 'SNES', 'NES', '3DS',
                        'PC', 'Android', 'iOS'],
                Movies: ['Theatrical', 'Blu-Ray', 'DVD', 'Digital Distribution', 'Netflix'],
                TV:     ['Broadcast', 'Blu-Ray', 'DVD', 'Digital Distribution', 'Netflix'],
                Music:  ['CD', 'Digital Distribution'],
                Books:  ['Paperback', 'Hardcover', 'Audiobook', 'Ebook'],
                Shoes:  ['Store', 'Online']
              }
              
categories.each do |category, media|
  category = Category.create(name: category.to_s)
  media.each do |medium|
    Medium.create(name: medium, category: category)      
  end
end

Category.where(name: "Games").first.update_attributes(icon: "fa fa-gamepad")
Category.where(name: "Movies").first.update_attributes(icon: "fa fa-film")
Category.where(name: "TV").first.update_attributes(icon: "fa fa-desktop")
Category.where(name: "Music").first.update_attributes(icon: "fa fa-headphones")
Category.where(name: "Books").first.update_attributes(icon: "fa fa-book")
Category.where(name: "Shoes").first.update_attributes(icon: "octicon octicon-steps")
              
regions = JSON.load(open("http://restcountries.eu/rest/v1/all"))

regions.each do |region|
  name = region["name"]
  Region.create(name: name)
end

# Add Global to regions
Region.create(name: "Global")

# Metacritic api key and base url
headers =  {"X-Mashape-Key" => ENV["X_MASHAPE_KEY"]}
base_url = "https://byroredux-metacritic.p.mashape.com/"


# Import metacritic data for movies and music
category = Category.where(name: "Games").first
region   = Region.where(name: "Global").first
game_platforms = {
                    "ps4"     => Medium.where(name: "PlayStation 4", category: category).first, 
                    "xboxone" => Medium.where(name: "Xbox One", category: category).first,
                    "ps3"     => Medium.where(name: "PlayStation 3", category: category).first,
                    "xbox360" => Medium.where(name: "Xbox 360", category: category).first,
                    "pc"      => Medium.where(name: "PC", category: category).first,
                    "wii-u"   => Medium.where(name: "Wii U", category: category).first,
                    "3ds"     => Medium.where(name: "3DS", category: category).first,
                    "vita"    => Medium.where(name: "PS Vita", category: category).first,
                    "ios"     => Medium.where(name: "iOS", category: category).first
                  }
                  
list_types = ["coming-soon", "new-releases"] 

list_types.each do |list_type| 
  game_platforms.each do |short_name, medium|
    releases = JSON.load(open("#{base_url}game-list/#{short_name}/#{list_type}", headers))
    
    releases["results"].each do |release|
      # Product info
      name        = release["name"]
      
      # LaunchDate info
      launch_date = release["rlsdate"]
      
      # Release info
      source         = release["url"] 
      
      product = Product.where(name: name, category: category).first_or_create
      launch_date_record = LaunchDate.where(launch_date: launch_date).first_or_create
      Release.where(product: product, region: region, launch_date: launch_date_record, medium: medium, source: source).first_or_create
    end
  end
end

# Import metacritic data for movies and music
music_category = Category.where(name: "Music").first
movies_category = Category.where(name: "Movies").first
data = [{category: music_category, medium: Medium.where(name: "CD", category: music_category).first, type: "album"},
       {category: movies_category, medium: Medium.where(name: "Theatrical", category: movies_category).first, type: "movie"}]

data.each do |datum|
  list_types.each do |list_type|
    request_url = "#{base_url + datum[:type]}-list/#{list_type}"
    releases = JSON.load(open(request_url, headers))
    releases["results"].each do |release|
        # Product info
        name        = release["name"]
        
        # LaunchDate info
        launch_date = release["rlsdate"]
        
        # Release info
        source      = release["url"] ? release["url"] : "http://www.metacritic.com"
        
        product = Product.where(name: name, category: datum[:category]).first_or_create
        launch_date_record = LaunchDate.where(launch_date: launch_date).first_or_create
        Release.where(product: product, region: region, launch_date: launch_date_record, medium: datum[:medium], source: source).first_or_create
    end
  end
end