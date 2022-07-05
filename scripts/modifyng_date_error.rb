
user_date = User.where("birth_date < '1922-01-01'").update_all(birth_date: nil)
user_date.save