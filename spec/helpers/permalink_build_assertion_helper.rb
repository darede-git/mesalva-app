# frozen_string_literal: true

module PermalinkBuildAssertionHelper
  def assert_permalink_build_worker_call(entity_class, entity_id)
    expect(PermalinkBuildWorker)
      .to receive(:perform_async) do |worker_entity_id, worker_entity_class|
      expect(worker_entity_id).to eq entity_id
      expect(worker_entity_class).to eq entity_class
    end
  end

  def skipped_attr?(attr)
    %w[image created_at updated_at updated_by created_by].include? attr
  end

  def assert_entity_attributes(entity, attributes)
    attributes.each do |k, v|
      next if skipped_attr?(k)

      expect(entity.public_send(k)).to eq v
    end
  end
end
