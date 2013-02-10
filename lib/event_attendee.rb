Attendee = Struct.new(:last_name, :first_name, :email_address, :zipcode, :city, :state, :street, :homephone)

class EventAttendee
  def initialize(filename)
  	@filename = filename
  end

  def get_attendees
    contents = CSV.open "data/#{@filename}", headers: true, header_converters: :symbol

    contents.each_with_object([]) do |person, data|
      last_name = person[:last_name].to_s
      first_name = person[:first_name].to_s
      email_address = person[:email_address].to_s
      zipcode = Zipcode.new(person[:zipcode].to_s).clean_zipcode
      city = person[:city].to_s
      state = person[:state].to_s
      street = person[:street].to_s
      homephone = Phone.new(person[:homephone].to_s).clean_phone_number
      attendee = Attendee.new(last_name, first_name, email_address, zipcode, city, state, street, homephone)
      data.push(attendee)
    end
  end
end