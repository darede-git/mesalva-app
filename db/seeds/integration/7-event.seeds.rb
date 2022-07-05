# frozen_string_literal: true
require 'me_salva/permalinks/builder'
require 'me_salva/event/user/last_modules_cache'

segment = FactoryBot.create(:node, name: 'New Education Segment', parent_id: 1)
subject = FactoryBot.create(:node,
                             name: 'New Subject',
                             node_type: 'subject',
                             parent_id: segment.id,
                             color_hex: 'ED4343')
node_module = FactoryBot.create(:node_module,
                                 name: 'New Node Module',
                                 node_ids: [subject.id])
item = FactoryBot.create(:item,
                          name: 'New Item',
                          item_type: 'video',
                          node_module_ids: [node_module.id])
FactoryBot.create(:medium,
                   name: 'New Video',
                   medium_type: 'video',
                   item_ids: [item.id],
                   seconds_duration: 600)
last_medium = FactoryBot.create(:medium,
                                 name: 'New Fixation Exercise',
                                 medium_type: 'fixation_exercise',
                                 audit_status: 'reviewed',
                                 item_ids: [item.id],
                                 answers_attributes: [{ "text": 'Alternativa 1',
                                                        "correct": 'true',
                                                        "active": 'true' },
                                                      { "text": 'Alternativa 2',
                                                        "correct": 'false',
                                                        "active": 'true' },
                                                      { "text": 'Alternativa 3',
                                                        "correct": 'false',
                                                        "active": 'true' },
                                                      { "text": 'Alternativa 4',
                                                        "correct": 'false',
                                                        "active": 'true' },
                                                      { "text": 'Alternativa 5',
                                                        "correct": 'false',
                                                        "active": 'true' }])

MeSalva::Permalinks::Builder.new(entity_id: segment.id, entity_class: 'Node')
                           .build_subtree_permalinks

%i(permalink_event_watch permalink_event permalink_event_answer).each do |p|
  2.times do
    10.times do |n|
      event = FactoryBot.build(p)
      event.permalink_medium_id = n
      event.permalink_slug = 'new-education-segment/new-subject/new-node-module'
      event.permalink_node = ['New Education Segment', 'New Subject']
      event.permalink_node_module = 'New Node Module'
      event.permalink_item = 'New Item'
      event.permalink_node_id = [segment.id, subject.id]
      event.permalink_node_module_id = node_module.id
      event.permalink_item_id = item.id
      event.permalink_node_slug = ['new-education-segment', 'new-subject']
      event.permalink_node_module_slug = 'new-node-module'
      event.permalink_item_slug = 'new-item'
      event.save!(validate: false)
    end
  end
end

# sleep 5
# ::Redis.current.del('consumed_media.1')
# ::Redis.current.del('consumed_modules.1')
# last_user_modules = MeSalva::Event::User::LastModulesCache
#                     .new(permalink_id: last_medium.permalinks.last.id,
#                          user_id: 1)
# last_user_modules.update

# ::Redis.current.del('syllabus.extensivo-medicina.user@integration.com.next')
# ::Redis
#   .current
#   .set('syllabus.extensivo-medicina.user@integration.com.next',
#          { 'name' => 'NNIN - Ciencias da Natureza: O que é?',
#            'slug' => 'nnin-intro-as-ciencias-da-natureza',
#            'permalink' => 'enem-e-vestibulares/materias',
#            'number' => '2' })

# ::Redis.current.del('syllabus.extensivo-medicina.user@integration.com.week.1')
# ::Redis
#   .current
#   .rpush('syllabus.extensivo-medicina.user@integration.com.week.1',
#          'nnin-introducao-as-ciencias-da-natureza-apresentacao')
