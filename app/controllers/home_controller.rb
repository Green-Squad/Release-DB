class HomeController < ApplicationController
  def index
    
    #Rails.cache.delete('home_page_upcoming_releases')
    @release_types = Rails.cache.fetch("home_page_upcoming_releases", :expires_in => 1.hour) do
      game_releases = coming_soon_releases("Games")
      movie_releases = coming_soon_releases("Movies")
      music_releases = coming_soon_releases("Music")
      
      release_types = { "Games" => releases_to_array(game_releases), "Movies" => releases_to_array(movie_releases), "Music" => releases_to_array(music_releases) }
    end
    
  end
  
  private
  
  def releases_to_array(releases)
    releases_array = []
    releases.each do |release|
      releases_array << {name: release[0], slug: release[1], launch_date: release[2]}
    end
    releases_array  
  end
  
  def coming_soon_releases(category)
    Release.joins(:launch_date, :product).distinct.where("launch_dates.launch_date > ? AND products.category_id = ?", Time.now, Category.where(name: category).first.id).order("launch_dates.launch_date, products.name").pluck("products.name, products.slug, launch_dates.launch_date").take(5)
  end
end
