class Release < ActiveRecord::Base
  require 'open-uri'
  
  include Approvable
  belongs_to :product
  belongs_to :launch_date
  belongs_to :medium
  belongs_to :region

  validates :product_id, presence: true
  validates :launch_date_id, presence: true
  validates :medium_id, presence: true
  validates :region_id, presence: true
  validates :source, presence: true
  
  def self.import
    Product.paper_trail_off!
    Release.paper_trail_off!
    
    # Metacritic api key and base url
    headers =  {'X-Mashape-Key' => ENV['X_MASHAPE_KEY']}
    base_url = 'https://byroredux-metacritic.p.mashape.com/'
    
    global_region = Region.where(name: "Global").first
    games_category = Category.where(name: 'Games').first
    music_category = Category.where(name: 'Music').first
    movies_category = Category.where(name: 'Movies').first
    game_platforms = {
      'ps4'     => Medium.where(name: 'PlayStation 4', category: games_category).first, 
      'xboxone' => Medium.where(name: 'Xbox One', category: games_category).first,
      'ps3'     => Medium.where(name: 'PlayStation 3', category: games_category).first,
      'xbox360' => Medium.where(name: 'Xbox 360', category: games_category).first,
      'pc'      => Medium.where(name: 'PC', category: games_category).first,
      'wii-u'   => Medium.where(name: 'Wii U', category: games_category).first,
      '3ds'     => Medium.where(name: '3DS', category: games_category).first,
      'vita'    => Medium.where(name: 'PS Vita', category: games_category).first,
      'ios'     => Medium.where(name: 'iOS', category: games_category).first
    }
    list_types = ['coming-soon', 'new-releases']

    # Import metacritic data for movies, games and music
    data = [{category: games_category, medium: game_platforms, type: 'game'},
            {category: music_category, medium: { 'cd' => Medium.where(name: 'CD', category: music_category).first }, type: 'album'},
            {category: movies_category, medium: { 'th' => Medium.where(name: 'Theatrical', category: movies_category).first }, type: 'movie'}]
    
    records_added = { products: [], releases: []}
    
    data.each do |datum|
      list_types.each do |list_type|
        datum[:medium].each do |short_name, medium|

          if datum[:type] == 'game'  
            request_url = "#{base_url + datum[:type]}-list/#{short_name}/#{list_type}"
          else
            request_url = "#{base_url + datum[:type]}-list/#{list_type}"
          end
          
          releases = JSON.load(open(request_url, headers))
          releases['results'].each do |release|
              # Product info
              name = release['name']
              
              # LaunchDate info
              launch_date = release['rlsdate']
              
              # Release info
              source = release['url'] ? release['url'] : 'http://www.metacritic.com'
              
              product = Product.where(name: name, category: datum[:category]).first
              unless product
                product = Product.create!(name: name, category: datum[:category])
                records_added[:products] << product
              end
              
              launch_date_record = LaunchDate.where(launch_date: launch_date).first_or_create
              
              release = Release.where(product: product, region: global_region, launch_date: launch_date_record, medium: medium, source: source).first
              unless release
                release = Release.create!(product: product, region: global_region, launch_date: launch_date_record, medium: medium, source: source)
                records_added[:releases] << release
              end
          end
        end
      end
    end
    Product.paper_trail_on!
    Release.paper_trail_on!
    
    ids = { Product: records_added[:products].map(&:id),
            Release: records_added[:releases].map(&:id) }
    
    records_added.each do |type, array|
      array.each do |record|
        record.update_attributes(updated_at: Time.now)
      end
    end
    
    ids.each do |type, array|
      PaperTrail::Version.where("item_id IN (?) AND item_type = ?", array, type.to_s).each do |version|
        version.update_attributes(status: "approved")
      end
    end
    
  end
end
