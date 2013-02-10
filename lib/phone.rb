class Phone

  def clean(phone)
    puts phone
    phone = phone.gsub(/[^0-9]/,"")
    case phone.length
    when phone.length < 10 then phone = "xxxxxxxxxx"
    when phone.length == 10 then phone
    when (phone.length == 11) && (phone[0] == 1) then phone = phone[1..-1]
    else
      phone = "xxxxxxxxxx"
    end
  end
end