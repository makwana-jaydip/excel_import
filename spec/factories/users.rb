# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Sample' }
    last_name { 'User' }
    email_id { 'sample.user@email.com' }
  end
end
