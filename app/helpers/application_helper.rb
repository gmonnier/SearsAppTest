module ApplicationHelper
	 # Return the page title
  def title
    base_title = "STWA"
    if @title.nil?
      base_title
    else
      "#{base_title} - #{@title}"
    end
  end

  def logo
  	return image_tag "logo.png" , :alt => "Logo picture" , :class => "pic"
  end
end
