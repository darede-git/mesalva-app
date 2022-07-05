# frozen_string_literal: true
FactoryBot.create(:study_plan_quiz_form_submission_with_answers, user_id: 1)
ActiveRecord::Base.connection.execute('ALTER SEQUENCE quiz_forms_id_seq RESTART WITH 10;')
ActiveRecord::Base.connection.execute('ALTER SEQUENCE quiz_questions_id_seq RESTART WITH 10;')

area_subject = Node.create!(
  name: 'Materias',
  node_type: 'area_subject',
  parent_id: Node.where(node_type: 'area').first.id,
  color_hex: 'ED4343'
)

node_module = NodeModule.find_by_slug('trigonometria')
node_module.nodes << area_subject
node_module.save

MeSalva::Permalinks::Builder.new(entity_id: area_subject.id,
                                entity_class: 'Node').build_subtree_permalinks

user = User.first
study_plan = FactoryBot.create(:study_plan, user_id: user.id)

FactoryBot.create(:study_plan)
permalink = Permalink.where('node_module_id is not null').first.node_module
FactoryBot.create(:study_plan_node_module,
                   study_plan_id: study_plan.id,
                   node_module_id: permalink.id)
FactoryBot.create(:study_plan_node_module,
                   study_plan_id: study_plan.id)
