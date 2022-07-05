def remove_users(platform_slug, emails)
  b2b_package_ids = [2760, 2737, 2840, 2946, 2907, 2940, 2956, 2926, 2905, 2957, 2958, 2959, 3091, 3092, 2994, 3043, 3099, 3101]
  platform = Platform.find_by_slug(platform_slug)

  emails.map do |email|
    user = User.find_by_email(email)
    vinculos_escola = UserPlatform.where(user_id: user.id, platform_id: platform.id)
    acessos_b2b = Access.where(user_id: user.id, package_id: b2b_package_ids)
    vinculos_escola.each do |vinculo|
      vinculo.active = false
      vinculo.save
    end
    acessos_b2b.each do |access|
      access.active = false
      access.save
    end
    {
      vinculos_escola: vinculos_escola,
      acessos_b2b: acessos_b2b,
    }
  end
end


