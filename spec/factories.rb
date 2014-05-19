FactoryGirl.define do
	factory :user do
		name	"Adam Lomas"
		email	"adam@example.com"
		password	"foobar"
		password_confirmation	"foobar"
	end
end