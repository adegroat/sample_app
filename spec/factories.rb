FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person.#{n}@mail.com" }
		password "monkey"
		password_confirmation "monkey"
		
		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content "I'm a micropost"
		user
	end
end
