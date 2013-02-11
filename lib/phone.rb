class Phone

  def clean(phone)
    phone = phone.gsub(/[^0-9]/,"")

    if phone.length == 10
      phone
    elsif phone.length < 10
      phone = "xxxxxxxxxx"
    elsif (phone.length == 11) && (phone[0] == 1)
      phone
    else
      phone = "xxxxxxxxxx"
    end
  end
end