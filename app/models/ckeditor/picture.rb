# frozen_string_literal: true

# Ckeditor picture model.
class Ckeditor::Picture < Ckeditor::Asset
  include Attachable

  has_attached_file :data, attachment_opts(
    url: '/ckeditor_assets/pictures/:id/:style_:basename.:extension',
    path: ':rails_root/public/ckeditor_assets/pictures/:id/:style_:basename.:extension',
    styles: { content: '800>', thumb: '118x100#' }
  )

  validates_attachment_presence :data
  validates_attachment_size :data, less_than: 100.megabytes
  validates_attachment_content_type :data, content_type: /\Aimage/

  def url_content
    url(:content)
  end
end
