require 'json'
require 'net/http'

@platforms = {}
@packages = {}

def get_platform(slug)
  return @platforms[slug] unless @platforms[slug].nil?
  @platforms[slug] = Platform.find_by_slug(slug)
end

def get_package(package_id)
  return @packages[package_id] unless @packages[package_id].nil?
  @packages[package_id] = Package.find(package_id)
end

def parse_users(rawUsers)
  users = []
  rawUsers.each do |data|
    data[:email] = data[:email] || data['email']
    data[:name] = data[:name] || data['name']
    data[:password] = data[:password] || data['password']
    data[:role] = data[:role] || data['role']
    data[:options] = data[:options] || data['options']
    data[:platform_slug] = data[:platform_slug] || data['platform_slug']
    data[:package_ids] = data[:package_ids] || data['package_ids']
    data[:send_mail] = data[:send_mail] || data['send_mail']
    data[:essay_corrector] = data[:essay_corrector] || data['essay_corrector']

    email = data[:email].downcase.strip
    platform = get_platform(data[:platform_slug])
    data = {
      user: {name: data[:name],email: email, uid: email, password: data[:password], objective_id: 4},
      user_platform: {role: data[:role], platform_id: platform.id , options: data[:options].reject { |key,value| value.empty? }},
      package_ids: data[:package_ids],
      platform: platform,
      send_mail: data[:send_mail],
      essay_corrector: data[:essay_corrector],
    }
    users << data
  end
  users
end

def save_user(user_data, send_mail)
  user = User.find_by_email(user_data[:email])
  unless user.nil?
    user.password = user_data[:password]
    user.save
    CpsScriptMailer.send_message(user_data[:email], user_data[:password]).deliver_now if send_mail
    return user
  end
  user = User.create(user_data)

  CpsScriptMailer.send_message(user_data[:email], user_data[:password]).deliver_now if send_mail
  user
end

def save_admin(user, user_data, essay_corrector)
  return nil unless essay_corrector
  admin = Admin.find_by_email(user_data[:email])
  admin = Admin.create(name: user_data[:name],email: user_data[:email]) if admin.nil?
  admin.encrypted_password = user.encrypted_password
  admin.save
end

def save_platform_user(user, platform, data)
  user_platform = UserPlatform.where(user_id: user.id, platform_id: platform.id).first
  unless user_platform.nil?
    user_platform.options = data[:options]
    return user_platform.save
  end
  if data[:role].nil?
    data[:role] = 'student'
  end
  puts '###'
  puts data
  puts '###'
  user_platform = UserPlatform.new(data)
  user_platform.user_id = user.id
  user_platform.save
end

def create_accesses(user, package_ids)
  package_ids.to_s.split(',').each do |package_id|
    package = get_package(package_id.strip)
    access = Access.where(user_id: user.id, package_id: package_id).last
    unless access.nil?
      access.expires_at = Time.now + 365.to_i.days
      access.save
      return access
    end
    access = MeSalva::User::Access.new.create(user, package, gift: 1, duration: 365)
    access.save
  end

end

def grant_cps_accesses(rawUsers)
  fails = []
  parse_users(rawUsers).map do |data|
    puts data
    begin
      platform = data[:platform]
      user = save_user(data[:user], data[:send_mail])
      save_admin(user,  data[:user], data[:essay_corrector])
      _user_platform = save_platform_user(user, platform, data[:user_platform])
      create_accesses(user, data[:package_ids])
    rescue
      fails << user
    end
    fails
  end
end

