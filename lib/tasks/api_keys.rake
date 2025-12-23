# frozen_string_literal: true

namespace :api_keys do
  desc "Generate a new API key"
  task :generate, [:name] => :environment do |_task, args|
    name = args[:name] || "Development Key"

    api_key = ApiKey.create!(
      name: name,
      active: true,
      expires_at: 1.year.from_now
    )

    puts "API Key created successfully!"
    puts "Name: #{api_key.name}"
    puts "Key: #{api_key.key}"
    puts "Expires: #{api_key.expires_at}"
    puts ""
    puts "Use this key in requests:"
    puts "curl -H 'Authorization: Bearer #{api_key.key}' http://localhost:3000/sessions"
    puts "or"
    puts "curl http://localhost:3000/sessions?api_key=#{api_key.key}"
  end

  desc "List all API keys"
  task list: :environment do
    ApiKey.find_each do |key|
      status = key.valid_key? ? "✓ Active" : "✗ Inactive"
      puts "#{key.name} - #{status} - Expires: #{key.expires_at&.strftime('%Y-%m-%d')}"
    end
  end

  desc "Revoke an API key by ID"
  task :revoke, [:id] => :environment do |_task, args|
    api_key = ApiKey.find(args[:id])
    api_key.update!(active: false)
    puts "API Key '#{api_key.name}' has been revoked"
  rescue ActiveRecord::RecordNotFound
    puts "API Key with ID #{args[:id]} not found"
  end
end
