module ApplicationHelper
  def affiliate_link(name, medium, category)
    "http://www.amazon.com/s/tag=gresqu-20&field-keywords=#{name} #{medium} #{category}"
  end
end
