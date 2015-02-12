# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'

Rails.cache.delete('region_list')
Rails.cache.delete('home_page_upcoming_releases')

Medium.delete_all
Product.delete_all
Category.delete_all
LaunchDate.delete_all
Region.delete_all
Release.delete_all
PaperTrail::Version.delete_all

Product.paper_trail_off!
Release.paper_trail_off!

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
global_region = Region.create(name: "Global")

# Metacritic api key and base url
headers =  {"X-Mashape-Key" => ENV["X_MASHAPE_KEY"]}
base_url = "https://byroredux-metacritic.p.mashape.com/"


# Import metacritic data for movies and music
category = Category.where(name: "Games").first
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
      Release.where(product: product, region: global_region, launch_date: launch_date_record, medium: medium, source: source).first_or_create
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
        Release.where(product: product, region: global_region, launch_date: launch_date_record, medium: datum[:medium], source: source).first_or_create
    end
  end
end

# Books
book_category = Category.where(name: "Books").first

books = [
          { name: "Halo: New Blood", launch_date: "2015-03-02", medium: "Ebook", source: "http://books.simonandschuster.com/Halo-New-Blood/Matt-Forbeck/9781476796703"},
          { name: "Halo: New Blood", launch_date: "2015-03-02", medium: "Audiobook", source: "http://books.simonandschuster.com/Halo-New-Blood/Matt-Forbeck/9781476796703"},
          { name: "Go Set a Watchman", launch_date: "2015-07-14", medium: "Ebook", source: "http://www.barnesandnoble.com/w/go-set-a-watchman-harper-lee/1121151104"},
          { name: "Go Set a Watchman", launch_date: "2015-07-14", medium: "Paperback", source: "http://www.barnesandnoble.com/w/go-set-a-watchman-harper-lee/1121151104"},
          { name: "Go Set a Watchman", launch_date: "2015-07-14", medium: "Hardcover", source: "http://www.barnesandnoble.com/w/go-set-a-watchman-harper-lee/1121151104"},
          { name: "Go Set a Watchman", launch_date: "2015-07-14", medium: "Audiobook", source: "http://www.barnesandnoble.com/w/go-set-a-watchman-harper-lee/1121151104"},
          { name: "The Whites", launch_date: "2015-02-15", medium: "Ebook", source: "http://www.barnesandnoble.com/w/the-whites-richard-price/1121153283"},
          { name: "The Whites", launch_date: "2015-02-15", medium: "Hardcover", source: "http://www.barnesandnoble.com/w/the-whites-richard-price/1121153283"},
          { name: "The Whites", launch_date: "2015-02-15", medium: "Audiobook", source: "http://www.barnesandnoble.com/w/the-whites-richard-price/1121153283"},
          { name: "A Touch of Stardust", launch_date: "2015-02-17", medium: "Ebook", source: "http://www.barnesandnoble.com/w/a-touch-of-stardust-kate-alcott/1119641174"},
          { name: "A Touch of Stardust", launch_date: "2015-02-17", medium: "Hardcover", source: "http://www.barnesandnoble.com/w/a-touch-of-stardust-kate-alcott/1119641174"},
          { name: "A Touch of Stardust", launch_date: "2015-02-17", medium: "Audiobook", source: "http://www.barnesandnoble.com/w/a-touch-of-stardust-kate-alcott/1119641174"},
          { name: "Minecraft: Blockopedia", launch_date: "2015-02-24", medium: "Hardcover", source: "http://www.barnesandnoble.com/w/minecraft-scholastic/1120018893"},
          { name: "The Assassin", launch_date: "2015-03-03", medium: "Ebook", source: "http://www.barnesandnoble.com/w/the-assassin-clive-cussler/1119859169"},
          { name: "The Assassin", launch_date: "2015-03-03", medium: "Hardcover", source: "http://www.barnesandnoble.com/w/the-assassin-clive-cussler/1119859169"},
          { name: "The Assassin", launch_date: "2015-03-03", medium: "Audiobook", source: "http://www.barnesandnoble.com/w/the-assassin-clive-cussler/1119859169"},
          { name: "I Hate Myselfie: A Collection of Essays by Shane Dawson", launch_date: "2015-03-10", medium: "Ebook", source: "http://www.barnesandnoble.com/w/i-hate-myselfie-shane-dawson/1120840897"},
          { name: "I Hate Myselfie: A Collection of Essays by Shane Dawson", launch_date: "2015-03-10", medium: "Paperback", source: "http://www.barnesandnoble.com/w/i-hate-myselfie-shane-dawson/1120840897"},
          { name: "Memory Man", launch_date: "2015-04-21", medium: "Ebook", source: "http://www.barnesandnoble.com/w/memory-man-david-baldacci/1120259031"},
          { name: "Memory Man", launch_date: "2015-04-21", medium: "Paperback", source: "http://www.barnesandnoble.com/w/memory-man-david-baldacci/1120259031"},
          { name: "Memory Man", launch_date: "2015-04-21", medium: "Hardcover", source: "http://www.barnesandnoble.com/w/memory-man-david-baldacci/1120259031"},
          { name: "Memory Man", launch_date: "2015-04-21", medium: "Audiobook", source: "http://www.barnesandnoble.com/w/memory-man-david-baldacci/1120259031"}
        ]
books.each do |book|
  product = Product.where(name: book[:name], category: book_category).first_or_create
  launch_date_record = LaunchDate.where(launch_date: book[:launch_date]).first_or_create
  medium_record = Medium.where(name: book[:medium]).first
  Release.where(medium: medium_record, region: global_region, launch_date: launch_date_record, product: product, source: book[:source]).first_or_create
end

# TV
tv_category = Category.where(name: "TV").first
tv_seasons = [
          { name: "Better Call Saul: Season 1", launch_date: "2015-02-08", medium: "Broadcast", source: "http://www.metacritic.com/tv/better-call-saul"},
          { name: "The Walking Dead: Season 5", launch_date: "2014-10-12", medium: "Broadcast", source: "http://www.metacritic.com/tv/the-walking-dead/season-5"},
          { name: "Game of Thrones: Season 5", launch_date: "2015-04-12", medium: "Broadcast", source: "http://en.wikipedia.org/wiki/Game_of_Thrones_(season_5)"},
          { name: "Archer: Season 6", launch_date: "2015-01-08", medium: "Broadcast", source: "http://en.wikipedia.org/wiki/List_of_Archer_episodes"},
          { name: "House of Cards: Season 3", launch_date: "2015-02-27", medium: "Netflix", source: "http://www.imdb.com/title/tt1856010/episodes?season=3&ref_=tt_eps_sn_3"}
        ]
tv_seasons.each do |season|
  product = Product.where(name: season[:name], category: tv_category).first_or_create
  launch_date_record = LaunchDate.where(launch_date: season[:launch_date]).first_or_create
  medium_record = Medium.where(name: season[:medium]).first
  Release.where(medium: medium_record, region: global_region, launch_date: launch_date_record, product: product, source: season[:source]).first_or_create
end

# Shoes
shoe_category = Category.where(name: "Shoes").first
shoes = [
          { name: "Air Jordan 10 Retro Dust/Metallic Gold-Black-Retro", launch_date: "2015-02-15", medium: "Online", source: "http://solecollector.com/Sneakers/Release-Dates/air-jordan-10-retro-remastered-cement-grey-black-tropical-teal/"},
          { name: "Nike Air Flight Huarache White/White-Ice", launch_date: "2015-02-15", medium: "Online", source: "http://solecollector.com/Sneakers/Release-Dates/nike-air-flight-huarache-white-white-ice/"},
          { name: "Nike KD VII Premium White/Metallic Gold-Pink Pow-Pure Platinum", launch_date: "2015-02-19", medium: "Online", source: "http://solecollector.com/Sneakers/Release-Dates/nike-kd-vii-premium-white-metallic-gold-pink-power-pure-platinum/"},
          { name: "Air Jordan 4 Retro LS Black/Black-Cool Grey", launch_date: "2015-02-21", medium: "Online", source: "http://solecollector.com/Sneakers/Release-Dates/air-jordan-4-retro-remastered-black-black-cool-grey/"},
          { name: "Nike Kobe X Black/Black-Persian Violet-Volt", launch_date: "2015-02-21", medium: "Online", source: "http://solecollector.com/Sneakers/Release-Dates/nike-kobe-x-black-black-persian-violet-volt/"},
          { name: "Nike LeBron 12 Merlot/Metallic Silver-Pink Flash-Volt", launch_date: "2015-28-02", medium: "Online", source: "http://solecollector.com/Sneakers/Release-Dates/nike-lebron-12-deep-burgundy-volt-pink-flash/"}
        ]
shoes.each do |shoe|
  product = Product.where(name: shoe[:name], category: shoe_category).first_or_create
  launch_date_record = LaunchDate.where(launch_date: shoe[:launch_date]).first_or_create
  medium_record = Medium.where(name: shoe[:medium]).first
  Release.where(medium: medium_record, region: global_region, launch_date: launch_date_record, product: product, source: shoe[:source]).first_or_create
end

Product.paper_trail_on!
Release.paper_trail_on!

Product.all.each do |product|
  product.update_attributes(updated_at: Time.now)
end

Release.all.each do |release|
  release.update_attributes(updated_at: Time.now)
end

PaperTrail::Version.all.each do |version|
  version.update_attributes(status: "approved")
end
