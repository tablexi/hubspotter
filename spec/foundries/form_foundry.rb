class FormFoundry
  def self.default_portal_id
    62515
  end

  def self.default_guid
    '0247d28d-0ddd-48ab-85a3-9a15b8c940e1'
  end

  def self.default_form_data
    {
      firstname: 'Test',
      email:     'test@example.com'
    }
  end

  def self.default_context_data
    {
      ipAddress: '192.0.2.0.1',
      pageUrl:   'http://example.com/form',
      pageName:  'Test Form Page'
    }
  end
end
