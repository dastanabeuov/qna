module ApplicationHelper
  ALERTS = { notice: "alert alert-info", success: "alert alert-success", 
             error: "alert alert-danger", alert: "alert alert-warning" }

  def flash_class(key)
    key.to_sym
    ALERTS[key] || "alert alert-danger"
  end

  def current_year
    Time.current.year
  end

  def github_url(author, repo)
    "https://github.com/#{ author }/#{ repo }"
  end

  def gist?(link)
    link[:url].include?('gist.github.com')
  end  
end
