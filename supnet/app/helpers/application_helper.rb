module ApplicationHelper

  def flash_class(level)
    case level
        when "notice" then "alert alert-info"
        when "alert" then "alert alert-warning"
        when "success" then "alert alert-success"
        when "error" then "alert alert-error"

    end
  end

end
