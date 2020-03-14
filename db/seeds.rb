# ['registered', 'banned', 'moderator', 'admin'].each do |role|
#   Role.find_or_create_by({name: role})
# end
require 'base64'

puts 'creating roles'
admin_role      = Role.create(name: 'admin', description: 'site admin')
business_role   = Role.create(name: 'business',
                              description: 'business development')
unassigned_role = Role.create(name: 'unassigned', description: 'unassigned')
deactivated_role = Role.create(name: 'deactivated', description: 'user with revoked access')


puts 'creating users'
harry = User.new
harry.email = 'harry.fairbanks@test.com'
harry.password = 'password'
harry.password_confirmation = 'password'
harry.role_id = admin_role.id
harry.first_name = 'Harry'
harry.last_name = 'Fairbanks'
harry.avatar = File.open(
  File.join(Rails.root, '/spec/fixtures/binaries/headshots/1.jpg')
)
harry.save!

bob = User.new
bob.email = 'bob@test.com'
bob.password = 'password'
bob.password_confirmation = 'password'
bob.role_id = admin_role.id
bob.first_name = 'Bob'
bob.last_name = 'Boberson'
bob.avatar = File.open(
  File.join(Rails.root, '/spec/fixtures/binaries/headshots/2.jpg')
)
bob.save!

user_array = [harry, bob]

(0...10).each do |i|
  user = User.new
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.avatar = File.open(
    File.join(Rails.root, "/spec/fixtures/binaries/headshots/#{i}.jpg")
  )
  user.email = "#{user.first_name}_#{i}@test.com"
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = business_role
  if i.odd?
    user.role = admin_role
  else
    user.role = business_role
  end
  user.save!
  user_array << user
end

# unassigned user is added at the end so
# they will be the last user in the Users index
unassigned = User.new
unassigned.email = 'unassigned@test.com'
unassigned.password = 'unassigned'
unassigned.role = unassigned_role
unassigned.first_name = 'Unassigned'
unassigned.last_name = 'Unassigned'
unassigned.save!
user_array << unassigned

puts 'creating request types'
bug     = RequestType.create(name: 'Bug', description: 'Software is broken.')
metric  = RequestType.create(name: 'Metric',
                             description: 'New data is required.')
issue   = RequestType.create(name: 'Issue',
                             description: 'Something needs to  be done.')
feature = RequestType.create(name: 'Feature',
                             description: 'New code is required.')

puts 'creating priorities'
low    = Priority.create(name: 'Low', description: 'Do when you can')
medium = Priority.create(name: 'Medium', description: 'Do before low')
high   = Priority.create(name: 'High', description: 'Do before medium')
urgent = Priority.create(name: 'URGENT', description: 'Do right now')

puts 'creating statuses'
triage      = Status.create(name: 'Triage', description: 'Not defined yet.')
backlog     = Status.create(name: 'Backlog',
                            description: 'Defined, but not assigned.')
assigned    = Status.create(name: 'Assigned',
                            description: 'Assigned, but not worked on.')
in_progress = Status.create(name: 'In Progress',
                            description: 'Being worked on.')
review      = Status.create(name: 'In Review',
                            description: 'Needs to pass review')
completed   = Status.create(name: 'Completed',
                            description: 'Completed and waiting on release')

puts 'creating verticals'
all        = Vertical.create(name: 'All', description: 'ALL Verticals')
staging    = Vertical.create(name: 'Staging', description: 'Staging')
production = Vertical.create(name: 'Production', description: 'Production')

puts 'prepping for task creation'
vertical_array = [all, staging, production]
request_type_array = [bug, metric, issue, feature]
priority_array = [low, medium, high, urgent]
status_array = [completed, review, in_progress, assigned, backlog, triage]

total_request_types = request_type_array.length
total_request_types -= 1
total_priorities = priority_array.length
total_priorities -= 1
total_users = user_array.length
total_users -= 1
total_verticals = vertical_array.length
total_verticals -= 1
total_statuses = status_array.length
total_statuses -= 1

puts 'creating tasks'

100.times do |n|
  puts "Task #{n}"

  attachment_array = []
  file_path = Rails.root.join('spec', 'fixtures', 'binaries', 'seed_files')
  sample_txt = "data:text/plain:base64," +
                  Base64.encode64(
                    File.open("#{file_path}/sample.txt", "rb").read)
  sample_csv = "data:text/csv:base64," +
                  Base64.encode64(
                    File.open("#{file_path}/sample.csv", "rb").read)
  sample_pdf = "data:application/pdf:base64," +
                  Base64.encode64(
                    File.open("#{file_path}/sample.pdf", "rb").read)

  attachment_array.push(
                        {
                          doc: sample_txt,
                          original_name: "sample.txt",
                          priority: 5
                        })
  attachment_array.push(
                        {
                          doc: sample_csv,
                          original_name: "sample.csv",
                          priority: 6
                        })
  attachment_array.push(
                        {
                          doc: sample_pdf,
                          original_name: "sample.pdf",
                          priority: 7
                          })

  (1..2).each do | i |
    puts "Attachment #{i} on Task #{n}"
    image_num = rand(1...30)
    image_string = "data:image/jpeg:base64," +
                      Base64.encode64(
                        File.open(
                          "#{file_path}/cat_#{image_num}.jpg", "rb").read)
    gif_num = rand(1..10)
    gif_string = "data:image/jpeg:base64," +
                    Base64.encode64(
                      File.open("#{file_path}/cat_#{gif_num}.gif", "rb").read)
    attachment_array.push(
                      {
                        doc: image_string,
                        original_name: "#{image_num}.jpg",
                        priority: n
                      })
    attachment_array.push(
                      {
                        doc: gif_string,
                        original_name: "#{gif_num}.gif",
                        priority: n
                        })
  end

  Task.create  title: Faker::Hipster.sentence.to_s,
               description: Faker::ChuckNorris.fact.to_s,
               reported_by: user_array[rand(0..total_users)],
               assigned_to: user_array[rand(0..total_users)],
               request_type: request_type_array[rand(0..total_request_types)],
               member_facing: [true, false].sample,
               vertical: vertical_array[rand(0..total_verticals)],
               required_by: Date.today.next_day(rand(0..30)),
               link: Faker::Internet.url.to_s,
               priority: priority_array[rand(0..total_priorities)],
               status: status_array[rand(0..total_statuses)],
               attachments_attributes: attachment_array
end
