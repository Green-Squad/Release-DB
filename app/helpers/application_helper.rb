module ApplicationHelper
  def affiliate_link(name, medium, category)
    "http://www.amazon.com/s/?tag=gresqu-20&field-keywords=#{name} #{medium} #{category}"
  end
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Release DB"
    if page_title.empty?
      base_title
    else
      page_title
    end
  end
end
