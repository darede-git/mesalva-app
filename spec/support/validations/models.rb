# frozen_string_literal: true

def should_be_present(*attributes)
  attributes.each do |attribute|
    it { should validate_presence_of attribute }
  end
end

def should_have_many(*relationships)
  relationships.each do |relationship|
    it { should have_many relationship }
  end
end

def should_belong_to(*entities)
  entities.each do |entity|
    it { should belong_to entity }
  end
end

def should_have_one(*entities)
  entities.each do |entity|
    it { should have_one entity }
  end
end

def should_validate_uniqueness_of(*entities)
  entities.each do |entity|
    it { should validate_uniqueness_of entity }
  end
end

def should_validate_have_and_belong_to_many(*entities)
  entities.each do |entity|
    it { should have_and_belong_to_many entity }
  end
end
