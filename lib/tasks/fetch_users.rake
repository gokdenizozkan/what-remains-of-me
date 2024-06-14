require 'net/http'

namespace :fetch_users do
  desc "Fetch users from external API and store them in the database."
  task import: :environment do
    url = URI.parse 'https://jsonplaceholder.typicode.com/users'
    request = Net::HTTP::Get.new url.to_s
    response = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http|
      http.request request
    }
    users = JSON.parse response.body

    users.each do |user|
      User.create(
        id: user['id'],
        name: user['name'],
        username: user['username'],
        email: user['email'],
        address: user['address'],
        company: user['company'],
        phone: user['phone'],
        website: user['website']
      )
    end

    puts 'Users imported successfully.'
  end
end