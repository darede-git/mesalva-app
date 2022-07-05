#retirando acesso de usuarios das plataforma
#através de uma lista de uids
user_uid_list = ['uma', 'lista', 'de', 'uids']
platform_slug = "slug da plataforma"

# Trata os dados
platform = Platform.find_by_slug(platform_slug)
user_list = User.where(uid: user_uid_list)

# Seta a lib
user_desactive = MeSalva::Platforms::UserPlatformRemover.new(platform)
# remove por lista
user_desactive.remove_user_list(user_list)

# também pode-ser remover por unico usuario
user_desactive.remove_user('uid do usuario')
