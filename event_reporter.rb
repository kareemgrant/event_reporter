$:.unshift("lib")

require 'csv'
require 'phone'
require 'zipcode'
require 'event_attendee'
require 'prompt'

Prompt.new("Welcome to EventReporter").run
