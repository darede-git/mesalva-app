# Para casos onde devemos cadastrar uma quantidade menor de alunos por vez (até uns 300), para mais que isso vale a
# pena usar o outro processo hospedando o json em algum lugar online
users = [
  { "name": "Nome do aluno", "platform_slug": "cps", "role": "student", "send_mail": true, "email": "email.do.aluno@etec.sp.gov.br", "password": "senha", "package_ids": 2994, "options": { "cpf": "cpf-do-aluno", "sede": "infos adicionais" } }
]
grant_cps_accesses(users)

