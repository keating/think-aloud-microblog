module ApplicationHelper
# Return a title on a per-page basis.
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  #logo helper
  def logo
    image_tag("x-men.png", :alt => "Sample App", :class => "round", :width => 29, :height => 29)
  end
end

