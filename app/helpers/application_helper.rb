module ApplicationHelper
  def resource_name(resource)
    resource.class.name.underscore.to_s
  end

  def render_result(object)
    klass = object.class.to_s
    case klass
    when "Question" then render 'search/question', question: object    
    when "Answer" then render 'search/answer', answer: object    
    when "User" then render 'search/user', user: object
    when "Comment"
      partial = object.commentable_type == 'Question' ? 'search/question_comment' : 'search/answer_comment'
      render partial, comment: object
    end
  end

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
