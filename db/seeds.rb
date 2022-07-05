Objective.where(name: 'Estudar para o ensino fundamental', education_segment_slug: nil)
         .first_or_create
Objective.where(name: 'Estudar para o ensino médio', education_segment_slug: 'ensino-medio')
         .first_or_create
Objective.where(name: 'Estudar para o curso técnico', education_segment_slug: nil)
         .first_or_create
Objective.where(name: 'Estudar para o ENEM e Vestibulares', education_segment_slug: 'enem')
         .first_or_create
Objective.where(name: 'Estudar para o ENEM', education_segment_slug: 'enem')
         .first_or_create
Objective.where(name: 'Estudar para vestibulares', education_segment_slug: 'enem')
         .first_or_create
Objective.where(name: 'Estudar Engenharia', education_segment_slug: 'engenharia')
         .first_or_create
Objective.where(name: 'Estudar Ciências da saúde', education_segment_slug: 'saude')
         .first_or_create
Objective
  .where(name: 'Estudar Negócios (Administração, ciências econômicas e afins)',
         education_segment_slug: 'negocios')
  .first_or_create
Objective.where(name: 'Estudar para concurso', education_segment_slug: nil)
         .first_or_create
Objective.where(name: 'Estudar para pós-graduação', education_segment_slug: nil)
         .first_or_create
Objective.where(name: 'Estudar para um conteúdo específico', education_segment_slug: nil)
         .first_or_create

EducationLevel.where(name: 'Ensino fundamental em andamento').first_or_create
EducationLevel.where(name: 'Ensino fundamental concluído').first_or_create
EducationLevel.where(name: 'Ensino médio em andamento').first_or_create
EducationLevel.where(name: 'Ensino médio concluído').first_or_create
EducationLevel.where(name: 'Ensino técnico em andamento').first_or_create
EducationLevel.where(name: 'Ensino técnico concluído').first_or_create
EducationLevel.where(name: 'Ensino superior em andamento').first_or_create
EducationLevel.where(name: 'Ensino superior concluído').first_or_create
EducationLevel.where(name: 'Pós graduação em andamento').first_or_create
EducationLevel.where(name: 'Pós graduação concluída').first_or_create
EducationLevel.where(name: 'Pré-vestibular').first_or_create

Admin.create(email: 'guilherme@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'jader.correa@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'maycon.seidel@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'guilherme.tassinari@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'pedro.cavalheiro@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'thales.yokoyama@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'guilherme.goncalves@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'andre.antunes@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'cesar.mazzillo@mesalva.com', password: 'M3S4lV4')
Admin.create(email: 'miguel@mesalva.com', password: 'M3S4lV4')
Teacher.create(email: 'maycon.seidel+1@mesalva.com', password: 'T34CH3r')
