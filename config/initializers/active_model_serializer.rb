ActiveModelSerializers.config.adapter = :json_api

class Date
  def as_json(options = nil) #:nodoc:
      strftime('%d-%m-%Y')
    end
end
