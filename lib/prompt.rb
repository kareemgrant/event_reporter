require_relative 'event_attendee'
# require 'csv'

class Prompt
  COMMANDS = {"load <filename>" => "Erase any loaded data and parse the specified file. If no filename is given, default to event_attendees.csv", 
                 "help" => "Output a dataing of the available individual commands",
                 "help <command>" => "Output a description of how to use the specific command",
                 "queue count" => "Output how many records are in the current queue",
                 "queue clear" => "Empty the queue",
                 "queue print" => "Print out a tab-delimited data table with a header row",
                 "queue print by <attribute>" => "Print the data table sorted by the specified attribute like zipcode",
                 "queue save to <filename.csv>" => "Export the current queue to the specified filename as a CSV",
                 "queue <attribute> <criteria>" => "Load the queue with all records matching the criteria for the given attribute",
                 "quit" => "Quit the EventReporter program"}

  def initialize(greeting)
    @greeting = greeting
    @data = []
    @queue = []
  end

  def run
    puts @greeting
    command = ""
    while command != "quit"
      printf "Enter command:"

      input = gets.chomp
      parts = input.split(" ")

      command = parts[0]
      options = parts[1..-1]

      process_command(command, options)
    end
  end

  def load_file(filename)
    @data = EventAttendee.new(filename).get_attendees
    puts "There were #{@data.length} records retrieved"
    # puts @data
    puts "Confirmation: #{filename} was successfully loaded"
    # reminder: check if file exists in the current directory
  end

  def help(*option)
    #puts option.inspect
    if option.empty?
      print_commands(COMMANDS)
    else
      #puts option[0..-1]
      command = option[0..-1].join(" ")
      #puts "the command passed into help: #{command}"
      if COMMANDS.include?(command)
        new_hash = Hash.new
        new_hash[command] = COMMANDS[command]
        print_commands(new_hash)
      else
        puts "In help method: Sorry that command is not supported"
      end
    end
  end

  def find(args)
    #puts "the the number of attendees in csv file: #{@data.length} "
    @queue = []
    array = args.split
    # puts "attribute: #{array[0]}"
    # puts "criteria: #{array[1]}"
    search(array[0], array[1])
  end

  def process_command(command, options)

    if command == 'load'
      if options[0].to_s == ""
        load_file("event_attendees.csv")
        puts "no option was specified so the event_attendees.csv file was loaded by default"
      else
        load_file(options[0..-1].join)
        puts "loaded the following file: #{options[0]}"
      end

    elsif command == 'help'
      args = options[0..-1]
      if args.empty?
        puts "call help method without arg"
        help
      else
        puts "call help method with arg"
        args.join(" ")
        help(args)
      end

    elsif command == 'find'
      args = options[0..-1]
      # call the find method by searching the data of attendees and returning an array
      if args.empty?
        puts "Cannot call find without an attribute and criteria"
      else
        # puts "calling find method with args"
        args = options[0..-1].join(" ")
        find(args)
      end

    elsif command == 'queue'
      args = options[0..-1]
      if args.empty?
        puts "You cannont call queue without specifying additional options"
      elsif args[0] == "count"
        # call queue_count
        queue_count
      elsif args[0] == "clear"
        # call queue_clear
        queue_clear
      elsif args[0] == "print" && args[1] != "by"
        # call queue_print
        queue_print
      elsif args[0] == "print" && args[1] == "by"
        sort_queue(args[2])
      elsif args[0] == "save" && args[1] == "to"
        queue_save(args[2])
      end
    else
      puts "Sorry that command is not supported"
    end
  end



  private 



  def search(attribute, criteria)
    #puts "In search method data is equal to #{@data}" 

    # puts "displaying attribute and criteria in search"
    # puts attribute
    # puts criteria

    @queue = @data.select {|person| person[attribute].downcase == criteria.downcase }
    # puts "Output of the queue in search method"
    # puts @queue.inspect

    # puts "#{@queue.length} records found"
    # print_results_header
    # print_queue(@queue)
  end

  def print_queue(queue)
    @queue.each do |person|
      print person["last_name"].ljust(25) + person["first_name"].ljust(15) + person["email_address"].ljust(30) + person["zipcode"].ljust(10) + person["city"].ljust(20) + person["state"].ljust(10) + person["street"].ljust(35) + person["homephone"].ljust(15) + "\n" 
    end

    # puts ""
    # puts "the results have been printed here is the current queue:"
    # puts @queue.inspect
    # puts ""
  end

  def sort_queue(attribute)
    puts "in sort_queue method"
    @queue = @queue.sort_by do |person|
      person[attribute].downcase
    end
    queue_print
  end


  def queue_count
    puts "There are #{@queue.size} records currently in the queue"
  end

   def queue_clear
    puts "clearing the queue"
    @queue = [] 
    puts "queue has been cleared"
  end

  def queue_print
    print_results_header
    print_queue(@data)
  end

  def queue_save(filename)
    # save data to external file
    row_array = []
   @queue.each do |person| 
      row_array.push(generate_row(person))
    end
    puts "in queue_save"
    puts row_array.inspect
    write_to_csv(row_array, filename)
  end

  def write_to_csv(row_array, filename)
    header_row = ["First_name", "Last_name", "Email_address", "Homephone", "Street", "City", "State", "Zipcode"]
    puts "in write_to_csv to method"
    Dir.mkdir("results") unless Dir.exists?("results") #create output dir unless it already exists
    CSV.open("results/#{filename}", "w") do |csv|
      csv << header_row
      row_array.each do |record|
        csv.add_row(record)
      end
    end
  end

  def generate_row(person)
    puts "in generate_row method with #{person["first_name"]}"
    person_row = []
    person.each do |k, v|
      person_row.push(v)
    end
    #person_row.inspect
    person_row
  end


  def border_line
    puts "-"*160
  end

  def header
    puts ""
    border_line
    print "Command".ljust(40) 
    print "Description".ljust(20) + "\n"
    border_line
  end

  def print_commands(commands_hash) # store this in a hash
    header
    commands_hash.each do |command, desc| 
      print command.ljust(40) + desc.ljust(15) + "\n"
    end
    border_line
  end

  def print_results_header
    puts ""
    border_line
    print "LAST NAME".ljust(25) + "FIRST NAME".ljust(15) + "EMAIL".ljust(30) + "ZIPCODE".ljust(10) + "CITY".ljust(20) + "STATE".ljust(10) + "ADDRESS".ljust(35) + "PHONE".ljust(10) + "\n"
    border_line
  end


end