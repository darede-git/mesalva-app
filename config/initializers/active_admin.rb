ActiveAdmin.setup do |config|
  config.site_title = "MS Admin"
  config.default_namespace = :panel
  config.comments = false
  config.batch_actions = true

  config.comments_registration_name = 'AdminComment'

  config.localize_format = :long

  config.namespace :root do |admin|
    admin.build_menu do |menu|
      menu.add label: 'Conteúdo'
      menu.add label: 'Relacionamento'
      menu.add label: 'Conversão'
    end
  end
end
