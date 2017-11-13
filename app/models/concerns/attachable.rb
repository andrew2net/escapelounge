# Add s3 storage functionality to model's attachments
module Attachable
  extend ActiveSupport::Concern

  # Options for s3 storage
  S3_OPTS = {
    storage:          :s3,
    s3_region:        'us-east-1', # TODO set your S3 region here
    s3_storage_class: { thumb: :REDUCED_REDUNDANCY },
    s3_credentials:   "#{Rails.root}/config/s3.yml"
  }

  module ClassMethods

    # Make attachments to be stored with s3 in production
    def attachment_opts(**opts)
      if Rails.env.production?
        opts.merge! S3_OPTS
      end
      opts
    end
  end
end
