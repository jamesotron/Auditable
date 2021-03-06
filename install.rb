# Install hook code here

require 'ftools'

auditable_dir = File.dirname(__FILE__)
rails_dir = File.join(auditable_dir, '..', '..', '..')

puts "* Generating model and migration..."
system "#{File.join(rails_dir, 'script', 'generate')} model audit auditable_type:string auditable_id:integer log:text identity:string"

if File.exists? File.join(rails_dir,'app','models','audit.rb')
  puts "* Backing up existing model.rb"
  File.move(File.join(rails_dir,'app','models','audit.rb'), File.join(rails_dir,'app','models','audit.rb.old'))
end

puts "* Making model polymorphic..."
model = File.open(File.join(rails_dir,'app','models','audit.rb'), 'w')
model.puts 'class Audit < ActiveRecord::Base'
model.puts '  belongs_to :auditable, :polymorphic => true'
model.puts 'end'
model.close

puts "* You probably want to run rake db:migrate now."

puts "* Done."
