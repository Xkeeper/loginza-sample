class User < ActiveRecord::Base
  attr_accessible :name, :username, :photo, :identity, :identifier, :email,
                    :provider, :provider_name, :nickname
  validates_length_of :username, :within => 4..12, :too_long => 'Username too long, max 12 symbols',
                      :too_short => 'Username too short, min 4 symbols'

  def identity=(value)
    self.identifier = value
  end

  def provider=(value)
    self.provider_name = value
  end

  def nickname=(value)
    self.username = value
  end

  def name=(value)
    str = nil

    if value.is_a?(Hash)
      value.symbolize_keys!
      str = value [:full_name] if value.has_key?(:full_name)
      str ||= [value[:first_name], value[:last_name]].join(' ') if value [:first_name] || value[:last_name]
    end
    str ||=value
    write_attribute(:name,str)
  end

  def self.find_or_create(attributes)
    attributes.symbolize_keys!
    client = where(:identifier => attributes[:identity]).first
    if client
      return client
    end
    client ||= new(attributes)
    result = client.save( :validate => false)
    client.username = "user#{client.id}" if result && !client.has_username?
    return client, result if client.save

  end

  def has_username?
    !self.username.blank?
  end

  def remember_token?
    (!remember_token.blank?) &&
        remember_token_expires_at && (Time.now < remember_token_expires_at.utc)
  end

  def refresh_token
    if remember_token?
      self.remember_token= self.class.make_token
      self.save
    end
  end

  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def self.make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token = self.class.make_token
    self.save()
  end

  def forget_me
    self.remember_token = nil
    self.remember_token_expires_at = nil
    self.save()
  end


end
