uids = %w[alana.insaurrauld@mesalva.com
ana.oliveira@mesalva.com
bruna.pereira@mesalva.com
camila.padilha@mesalva.com
fabiola.correa@mesalva.com
helen.almeida@mesalva.com
helen.nunes@mesalva.com
isabella.borin@mesalva.com
julieny.santos@mesalva.com
julia.migot@mesalva.com
lucas.moraes@mesalva.com
mariaeduarda.dagostini@mesalva.com
nathalie.soares@mesalva.com
nicolas.souza@mesalva.com
rebecca.santos@mesalva.com
thaina.brandao@mesalva.com
thaina.lima@mesalva.com
yan.azevedo@mesalva.com
yuri.goulart@mesalva.com]
role_slug = 'sales'

role = Role.find_by_slug(role_slug)

uids.each do |uid|
  user = User.find_by_email(uid)
  if user.nil?
    puts 'não encontrado'
  else
    next if UserRole.where(user: user, role: role, user_platform_id: nil).count.positive?

    UserRole.create(user: user, role: role)
  end
end
