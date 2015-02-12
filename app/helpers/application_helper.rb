module ApplicationHelper
  def affiliate_link(name, medium, category)
    "http://www.amazon.com/s/?tag=gresqu-20&field-keywords=#{name} #{medium} #{category}"
  end
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Release Dates"
    if page_title.empty?
      base_title
    else
      page_title
    end
  end
  
  def get_categories()
    categories = Category.all
    category_array = []
    categories.each do |category|
      category_array << category.name
    end
    category_array.to_sentence
  end
end
