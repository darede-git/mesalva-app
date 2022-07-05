# frozen_string_literal: true

class AttachmentUploaderWorker
  include Sidekiq::Worker

  def perform(medium_slug)
    MeSalva::Aws::Unzip.new.unzip_medium(medium_slug)
  end
end
