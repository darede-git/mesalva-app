class AdminToUserConverter

  def initialize
    @roles = {}
    @report = []
    Role.all.each do |role|
      @roles[role.name] = role
    end
    @admins = Admin.where(active: true)
  end

  def convert
    @report = []
    @admins.each do |admin|
      convert_one(admin)
    end
    pp @report
  end

  def convert_one(admin)
    role_name = admin.role || 'teacher'
    role = @roles[role_name]
    user = get_or_create_user(admin)
    user_role = UserRole.where(user_id: user.id, role_id: role.id).first
    if user_role.nil?
      user_role = UserRole.create(user_id: user.id, role_id: role.id)
    end
    user_role_id = user_role.id
    @report << "#{role.name}(#{role.id}): #{admin.uid} <> #{user.uid} [#{user_role_id}]"
  end

  def get_or_create_user(admin)
    user = User.where("uid = :uid OR email = :email", {uid: admin.uid, email: admin.email}).first
    return user unless user.nil?

    create_user_admin_based(admin)
  end

  def create_user_admin_based(admin)
    user_data = JSON.parse(admin.to_json)
    user_data.tap { |hs| hs.delete('id'); hs.delete('role'); hs.delete('nickname'); hs.delete('description') }
    user_data['encrypted_password'] = admin.encrypted_password
    User.create(user_data)
  end
end

# AdminToUserConverter.new.convert
