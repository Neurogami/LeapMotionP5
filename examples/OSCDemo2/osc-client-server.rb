#!/usr/bin/env ruby
#

require 'osc-ruby-ng'

include  OSC

$OSC_DUMP_PORT = 8000
$OSC_ADDY = '127.0.0.1'

if ARGV[0]
  $OSC_DUMP_PORT  = ARGV.shift.to_i
end

if ARGV[0]
  $OSC_ADDY = ARGV.shift
end

@server = Server.new $OSC_DUMP_PORT

warn "Running on #{$OSC_ADDY}:#{$OSC_DUMP_PORT}"

@server.add_method /.*/ do |msg|
  message = msg.address
  args = msg.to_a
  puts "#{message} #{args}"
end

t = Thread.new do
  @server.run
end

t.join
puts "All done!"
