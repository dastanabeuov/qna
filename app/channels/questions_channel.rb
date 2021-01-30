class QuestionsChannel < ApplicationCable::Channel
	def questions_list
    stream_from 'questions-list'
	end
end