class User < ApplicationRecord
  # Address virtual attributes
  def street
    address['street']
  end

  def street=(value)
    self.address ||= {}
    self.address['street'] = value
  end

  def suite
    address['suite']
  end

  def suite=(value)
    self.address ||= {}
    self.address['suite'] = value
  end

  def city
    address['city']
  end

  def city=(value)
    self.address ||= {}
    self.address['city'] = value
  end

  def zipcode
    address['zipcode']
  end

  def zipcode=(value)
    self.address ||= {}
    self.address['zipcode'] = value
  end

  def lat
    address['geo']['lat']
  end

  def lat=(value)
    self.address ||= {}
    self.address['geo'] ||= {}
    self.address['geo']['lat'] = value
  end

  def lng
    address['geo']['lng']
  end

  def lng=(value)
    self.address ||= {}
    self.address['geo'] ||= {}
    self.address['geo']['lng'] = value
  end

  # Company virtual attributes
  def company_name
    company['name']
  end

  def company_name=(value)
    self.company ||= {}
    self.company['name'] = value
  end

  def catch_phrase
    company['catchPhrase']
  end

  def catch_phrase=(value)
    self.company ||= {}
    self.company['catchPhrase'] = value
  end

  def bs
    company['bs']
  end

  def bs=(value)
    self.company ||= {}
    self.company['bs'] = value
  end
end
