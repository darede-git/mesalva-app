UserPlatform.where('platform_unity_id IS NOT NULL').update_all(platform_unity_id: nil)
PlatformUnity.destroy_all


Platform.all.each do |platform|
  user_platforms = ActiveRecord::Base.connection.execute(
    "SELECT DISTINCT(unity) FROM user_platforms WHERE platform_id = #{platform.id}"
  )

  updates = user_platforms.map do |user_platform|
    unity_name = user_platform['unity'].nil? ? 'Geral' : user_platform['unity']
    PlatformUnity.where(name: unity_name, platform_id: platform.id).first
    platform_unity = PlatformUnity.create(name: unity_name, platform_id: platform.id)
    UserPlatform.where(platform_id: platform.id, unity: user_platform['unity'], platform_unity_id: nil).update_all(platform_unity_id: platform_unity.id)
  end
end
