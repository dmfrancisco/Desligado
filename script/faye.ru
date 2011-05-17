# Run this file typing the command: rackup faye.ru -s thin -E production
require 'faye'
faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45)
run faye_server
