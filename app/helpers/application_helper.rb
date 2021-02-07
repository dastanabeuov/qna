module ApplicationHelper
  def flash_key(key)
  	key.to_s
  	if key == 'notice'
  		'success'
  	elsif key == 'alert'
  		'warning'
  	else
  		key
  	end	
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
