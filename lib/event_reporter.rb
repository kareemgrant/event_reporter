require_relative 'prompt'

prompt = Prompt.new("Welcome to EventReporter")
prompt.run 

# require_relative 'event_attendee'

# def border_line
#   puts "-"*160
# end

# def header
#   border_line
#   print " Command".ljust(40) 
#   print "Description".ljust(20) + "\n"
#   border_line
# end

# commands_hash = {" load <filename>" => "Erase any loaded data and parse the specified file. If no filename is given, default to event_attendees.csv", 
#                  " help" => "Output a listing of the available individual commands",
#                  " help <command>" => "Output a description of how to use the specific command",
#                  " queue count" => "Output how many records are in the current queue",
#                  " queue clear" => "Empty the queue",
#                  " queue print" => "Print out a tab-delimited data table with a header row",
#                  " queue print by <attribute>" => "Print the data table sorted by the specified attribute like zipcode",
#                  " queue save to <filename.csv>" => "Export the current queue to the specified filename as a CSV",
#                  " queue <attribute> <criteria>" => "Load the queue with all records matching the criteria for the given attribute",
#                  " quit" => "Quit the EventReporter program"}

# attributes_array = ["regdate", "first_name", "last_name", "email_address", "homephone", "street", "city", "state", "zipcode"]

#puts commands_hash.inspect


# def print_commands(commands_hash) # store this in a hash

#   commands_hash.each do |command, desc| 
#     print command.ljust(40) + desc.ljust(15) + "\n"
#   end
#   border_line

#   # print " load <filename>".ljust(40) +  "Erase any loaded data and parse the specified file. If no filename is given, default to event_attendees.csv".ljust(15) + "\n"
#   # print " help".ljust(40) +  "Output a listing of the available individual commands".ljust(15) + "\n"
#   # print " help <command>".ljust(40) +  "Output a description of how to use the specific command".ljust(15) + "\n"
#   # print " queue count".ljust(40) +  "Output how many records are in the current queue".ljust(15) + "\n"
#   # print " queue clear".ljust(40) +  "Empty the queue".ljust(15) + "\n"
#   # print " queue print".ljust(40) +  "Print out a tab-delimited data table with a header row".ljust(15) + "\n"
#   # print " queue print by <attribute>".ljust(40) +  "Print the data table sorted by the specified attribute like zipcode".ljust(15) + "\n"
#   # print " queue save to <filename.csv>".ljust(40) +  "Export the current queue to the specified filename as a CSV".ljust(15) + "\n"
#   # print " queue <attribute> <criteria>".ljust(40) +  "Load the queue with all records matching the criteria for the given attribute".ljust(15) + "\n"
#   # print " quit".ljust(40) +  "Quit the EventReporter program".ljust(15) + "\n"
#   # border_line
# end

# def print_results_header
#   border_line
#   print "LAST NAME".ljust(20) + "FIRST NAME".ljust(20) + "EMAIL".ljust(20) + "ZIPCODE".ljust(10) + "CITY".ljust(15) + "STATE".ljust(15) + "ADDRESS".ljust(25) + "PHONE".ljust(15) + "\n"
#   border_line
# end

#header
#print_commands(commands_hash)

# def run
#   puts "Welcome to EventReporter"
#   command = ""
#   while command != "quit"
#     printf "Enter command:"

#     input = gets.chomp
#     parts = input.split(" ")

#     command = parts[0]
#     options = parts[1..-1]

#     process_command(command, options)

#     # case command
#     #   when "load" then # do something
#     #   when "load" then # do something
#     #   when "load" then # do something
#     #   when "load" then # do something
#     #   when "load" then # do something
#     #   when "load" then # do something
#     #   when "load" then # do something

#     # if command == 'load'
#     #   if option != "" 
#     #     # load filename provided as an option
#     #   else
#     #     # no filename specified, load event_attendees.csv by default
#     #   end
#     # elsif command == "help"
#     #   if option != ""
#     #     # display the description of the command that is passed in
#     #   else
#     #     # display list of all of the available commands
#     #   end
#     # elsif command == "queue"
#     #   if option == "count"
#     #     # count the number of records in the queue
#     #   elsif option == "clear"
#     #     # empty the queue
#     #   elsif option = "print"
#     #     if parts[2].to_s != ""
#     #       # print out table
#     #     elsif parts[2].to_s != ""
#     #     end
#     #   elsif 
#     #   elsif
#     #   end
#     # elsif condition
#     # end


#   end
# end

# def process_command(command, options)
#   #options.length

#   if command == 'load'
#     if options[0].to_s == ""
#       list = EventAttendee.new("event_attendees.csv")
#       puts "no option was specified so the event_attendees.csv file was loaded by default"
#     else
#       list = EventAttendee.new(options[0])
#       puts "loaded the following file: #{options[0]}"
#     end
#   else
#     puts "Sorry that command is not supported"
#   end

# end





# print_header

#list = EventAttendee.new("event_attendees.csv").get_attendees
# puts list.each {|person| puts person}
# puts "***"

# puts list.class

# conduct rudimentary search

# results = list.select {|person| person[:first_name].downcase == 'shannon' }

# puts "Search results"
# puts results



# sorted_list = list.sort_by do |person|
#   person[:last_name].downcase
#   # puts person.class
#   #puts " "
# end

# sorted_list.each {|person| puts person}