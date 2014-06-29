class ContactFoundry
    def self.default_properties(new_properties = {})
    { email: 'totallynewuser@example.com' }.merge(new_properties)
  end

  def self.default_vid
    231258
  end

  def self.duplicate_email_properties
    { email: 'test@example.com' }
  end
end
