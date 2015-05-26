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
end
