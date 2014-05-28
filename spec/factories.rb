FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person.#{n}@mail.com" }
		password "monkey"
		password_confirmation "monkey"
	end
end
