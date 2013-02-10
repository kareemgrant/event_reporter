require 'csv'
require './lib/phone'
require './lib/zipcode'
# require './lib/event_attendee'
require './lib/result'
require './lib/printer'
require './lib/file_parser'
# require './lib/prompt'
require 'yaml'

class EventReporter
  def initialize
    @queue = Result.new
    @data = FileParser.new
  end

  def run_program
    puts "Welcome to EventReporter"

    command = ""
    while command != "quit"
      printf "Enter command:"
      command, options = parse_user_input
      # puts command
      # puts options.inspect
      route_user_input(command, options)
    end
  end

  def parse_user_input
      command = ""

      input = gets.chomp.downcase
      parts = input.split(" ")

      command = parts[0]
      options = parts[1..-1]
      # puts command
      # puts options.inspect

      return command, options
  end

  def route_user_input(command, options)
    method = "process_#{command}"
    puts "Method name: #{method}"

    if respond_to?(method)
      send(method, options)
    end
  end

  def process_help(options)
    command = options.join(" ")

    yml = YAML.load_file('lib/help.yml')

    if command != "" && yml[command].nil?
      puts "Unknown Command: #{command} is not a valid EventReporter command"
    else
      #printer = Printer.new.print_commands(command)
    end
  end

  def process_load(options)
    puts "in process_load method"
    puts options.inspect

    filename = options[0..-1].join.to_s
    filename = "event_attendees.csv" if filename == ""

    puts "Filename: #{filename}"

    if File.exists?("data/#{filename}")
      puts "parser will retrieve data array"
      @data = FileParser.new.get_data(filename)
      puts @data.inspect
    else
      puts "File does not exist"
    end
  end

  def process_queue(options)
    puts "in process_queue method"
    puts options.inspect
  end

  def process_find(options)
    puts "in process_find method"
    puts options.inspect
  end

  def process_quit(options)
    puts "in process_quit method"
    puts options.inspect
  end


end

er = EventReporter.new.run_program
