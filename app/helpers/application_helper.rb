module ApplicationHelper
	def correct_title(title)
		title.empty? ? "Sample App" : "#{title} - Sample App"
	end
end
