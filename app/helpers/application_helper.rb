module ApplicationHelper
  # This could be changed into partial later on
  def flash_messages
    flash.map do |key, message|
      content_tag :p, message, class: key
    end.join.html_safe
  end
end
