# frozen_string_literal: true

RSpec.shared_examples 'a removable related entity' do |entities|
  entities.each do |entity|
    context "when removing #{entity[:related]} from #{entity[:self]}" do
      context 'strong parameters (rails) turns empty array into nil param' do
        it 'removes relation when receiving empty array' do
          self_entity = create(entity[:self])
          related_entities = create_related_list(entity[:related])
          self_entity.public_send("#{entity[:related]}_ids=",
                                  related_entities.map(&:id))

          expect(self_entity.public_send("#{entity[:related]}_ids").count)
            .to be_positive

          put :update, params: { id: self_entity,
                                 "#{entity[:related]}_ids": nil }

          self_entity.reload
          expect(self_entity.public_send("#{entity[:related]}_ids")).to be_empty
        end
      end
    end
  end
end

RSpec.shared_examples 'controller #update with inactive "has_many" relations' \
  do |entities|
  entities[:relations].each do |relation|
    context "update #{entities[:entity]} with "\
      "an inactive #{relation}" do
      it "updates the #{entities[:entity]}" do
        entity = create(entities[:entity])
        relations = []
        relation_ids = []
        3.times do
          rel = create(relation)
          rel.update("#{entities[:entity].to_s.pluralize}": [entity])
          relations << rel
          relation_ids << rel.id
        end
        relations.last.active = false
        relations.last.save!

        put :update, params: { id: entity, name: 'new name',
                               "#{relation}_ids": relation_ids }
      end
    end
  end
end

RSpec.shared_examples 'permalink with inactive entity relatives' do |entities|
  entities[:relations].each do |relation|
    it "does not show inactive entities" do
      relation_plural = relation.to_s.pluralize

      permalink = Permalink.find(permalink_id)
      entity = entities[:entity].to_s.camelize.constantize.find(entity_id)

      entity.public_send(relation_plural).first.update(active: false)
      new_rel = create(relation)
      new_rel.update("#{entities[:entity].to_s.pluralize}": [entity])

      entity.reload
      relations = entity.public_send(relation_plural).to_a
      relations.shift
      relation_ids = relations.map(&:id)
      relation_names = relations.map(&:name)
      relation_slugs = relations.map(&:slug)

      get :show, params: { slug: permalink.slug }

      expect(response_last_entity[relation_plural.dasherize].count)
        .to eq relations.count

      response_relation_uids = response_last_entity[relation_plural.dasherize]
                               .map { |i| i['id'] || i['name'] || i['slug'] }

      expect(response_relation_uids).to be_in([relation_ids,
                                               relation_names,
                                               relation_slugs])
    end
  end
end
