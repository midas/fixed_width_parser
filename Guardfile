#!/usr/bin/env ruby

# guard 'shell' do
#   watch( 'fixed_width_parser.rb' ) { |m| `ruby fixed_width_parser.rb` }
# end

guard 'rspec', :version => 2, :all_on_start => true, :all_after_pass => false, :cli => '--color --format doc' do
  watch( %r{^spec/.+_spec\.rb$} )
  watch( %r{^lib/(.+)\.rb$} )     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch( 'spec/spec_helper.rb' )  { "spec" }
end
