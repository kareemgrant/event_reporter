class Phone

  ONE = "1"

  def initialize(phone)
    @phone = phone.gsub(/[^0-9]/,"")
  end

  def clean_phone_number
    if @phone.length < 10
      @phone = "xxxxxxxxxx"
    elsif @phone.length == 10
      @phone
    elsif @phone.length == 11 && @phone[0] == ONE
       @phone[1..-1]
    elsif @phone.length == 11 && @phone[0] != ONE
      @phone = "xxxxxxxxxx"
    else # all other conditions including phone.length > 11
      @phone = "xxxxxxxxxx"
    end

    return @phone
  end
end