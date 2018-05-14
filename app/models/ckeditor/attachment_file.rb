# frozen_string_literal: true

class Ckeditor::AttachmentFile < Ckeditor::Asset
  include Attachable

  has_attached_file :data, attachment_opts(
    url: '/ckeditor_assets/attachments/:id/:filename',
    path: ':rails_root/public/ckeditor_assets/attachments/:id/:filename'
  )

  validates_attachment_presence :data
  validates_attachment_size :data, less_than: 100.megabytes
  do_not_validate_attachment_file_type :data

  def url_thumb
    @url_thumb ||= Ckeditor::Utils.filethumb(filename)
  end
end
