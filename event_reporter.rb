## ToDo
### 1) Add exception handling, experiment with throw/catch and begin/rescue
###    blocks

require 'csv'
require './lib/phone'
require './lib/zipcode'
require './lib/result'
require './lib/printer'
require './lib/file_parser'
require './lib/file_writer'
require 'yaml'

class EventReporter

  def run_program
    puts "Welcome to EventReporter"

    command = ""
    while command != "quit"
      printf "Enter command:"
      command, options = parse_user_input
      route_user_input(command, options)
    end
  end

  def parse_user_input
      command = ""

      input = gets.chomp.downcase
      parts = input.split(" ")

      command = parts[0]
      options = parts[1..-1]

      return command, options
  end

  def route_user_input(command, options)
    method = "process_#{command}"

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
      printer = Printer.new.print_commands(command)
    end
  end

  def process_load(options)

    filename = options[0..-1].join.to_s
    filename = "event_attendees.csv" if filename == ""

    puts "Filename: #{filename}"

    if File.exists?("data/#{filename}")
      @data = FileParser.new.get_data(filename)
      puts @data.size
    else
      puts "File does not exist"
    end
  end

  def process_find(options)
    if options.size < 2
      puts "Missing attribute and/or condition"
    else
      @data ||= FileParser.new.data
      @results = Result.new

      options = options[0..-1].join(" ")
      queue = @results.find(@data, options)
      puts "#{queue.size} results found"
    end
  end

  def process_queue(options)
    if options.empty?
      puts "Missing args"
    else
      method = parse_queue_input(options)
      #puts method

      @results ||= Result.new


      if @results.respond_to?(method)
        @results.send(method, options.join(" "))
      else
        puts "queue_#{method} is an invalid command"
      end

    end
  end

  def parse_queue_input(options)
    case options[0].downcase
    when "clear" then message = "clear"
    when "count" then message = "count"
    when "print" then message = "print"
    when "save" then message = "save"
    else
      puts "Invalid command"
    end
    message
  end

  def process_quit(options)
    puts "Goodbye"
    exit
  end

end

er = EventReporter.new.run_program
