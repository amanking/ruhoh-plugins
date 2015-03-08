require 'rspec'
require 'ruhoh'

Dir["**/*.rb"].each { |file| require File.expand_path(file, ".") unless file =~ /^spec|vendor|\./ }