require_relative '../app/assets/constants'

puts 'Destroying all asanas...'
Asana.destroy_all

puts 'Creating asanas...'

ASANAS.each do |asana|
  Asana.create!(title: asana[:title],
                benefits: asana[:benefits],
                contraindications: asana[:contraindications],
                alternatives_and_options: asana[:alternatives_and_options],
                counterposes: asana[:counterposes],
                meridians_and_organs: asana[:meridians_and_organs],
                joints: asana[:joints],
                recommended_time: asana[:recommended_time],
                other_notes: asana[:other_notes],
                into_pose: asana[:into_pose],
                out_of_pose: asana[:out_of_pose])
end

puts 'Asanas created!'
puts "Created #{Asana.count} asanas."

puts 'Destroying all sessions...'
Session.destroy_all

puts 'Creating sessions...'

FLOWS.each do |flow|
  session = Session.create!(
    name: flow[:name],
    description: flow[:description] || 'No description provided'
  )

  flow[:asanas].each do |asana|
    session.timers.create!(
      title: asana[:name],
      duration: asana[:duration]
    )
  end
end
