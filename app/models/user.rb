class User < ApplicationRecord
  before_update :prevent_update_if_username_exists

  def image_url
    self.class.get("https://picsum.photos/id/#{self.id}/info")['download_url']
  end

  def albums
    albums = []
    album_ids = []
    self.class.get('https://jsonplaceholder.typicode.com/albums').each do |album|
      next unless album['userId'] == self.id
      album_ids << album['id']
      albums << {id: album['id'], title: album['title'], photos: []}
    end

    self.class.get('https://jsonplaceholder.typicode.com/photos').each do |photo|
      index = album_ids.find_index photo['albumId']
      next if index.nil?
      p = {url: photo['url'], thumbnail_url: photo['thumbnailUrl'], title: photo['title']}
      albums[index][:photos] << p
    end
    puts albums
    albums
  end

  def album_titles
    self.class.fetch 'https://jsonplaceholder.typicode.com/albums', 'userId', self.id, 'title'
  end

  def album_photo_urls
    self.class.fetch 'https://jsonplaceholder.typicode.com/photos', 'albumId', self.id, 'url'
  end

  def album_thumbnail_urls
    self.class.fetch 'https://jsonplaceholder.typicode.com/photos', 'albumId', self.id, 'thumbnailUrl'
  end

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

  def full_address
    "#{street}, #{suite}, #{zipcode} #{city}"
  end

  def address=(street, suite, city, zipcode, lat, lng)
    street= street
    suite= suite
    city= city
    zipcode= zipcode
    lat= lat
    lng= lng
    full_address
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

  private
  def self.get(url)
    uri = URI.parse url
    request = Net::HTTP::Get.new uri.to_s
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http|
      http.request request
    }
    JSON.parse response.body
  end

  def self.fetch(target_url, lookup_name, lookup_id, resource_name)
    resources = get(target_url)

    desireds = []
    resources.each do |resource|
      next unless resource[lookup_name] == lookup_id
      desireds << resource[resource_name]
    end
    desireds
  end

  def username_exists?
    User.where(username: self.username).first.present?
  end

  def prevent_update_if_username_exists
    if username_exists?
      errors.add :username, 'This username is already being used. Choose something else.'
      throw :abort
    end
  end
end
