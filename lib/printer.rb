require 'yaml'

class Printer
  # def initialize(queue)
  #   @queue = queue
  # end

  def border_line
    puts "-"*180
  end

  def header
    puts ""
    border_line
    print "Command".ljust(45)
    print "Description".ljust(20) + "\n"
    border_line
  end

  def print_commands(command)

    yml = YAML.load_file('lib/help.yml')

    header

    if command == ""
      yml.each_pair do |key, value|
        puts value
      end
    else
      puts yml[command]
    end

    border_line
  end

end