class GoogleDriveService
  def initialize(credentials:)
    @drive = Google::Apis::DriveV3::DriveService.new
    @drive.authorization = credentials
  end

  # TODO: Add VCR tests
  # TODO: use block |resp, err| to not block
  def copy(from:, to:)
    *path, new_file_name = to.split('/')
    raise 'Too many directories in path' if path.size > 2

    # TODO: we should probably also enforce the path for from
    from_file = files(name: from).first
    copied_file = @drive.copy_file(from_file.id, fields: 'id, parents')

    origin_id = copied_file.parents.first
    destination_id = destination_directory_id(path:)
    # NOTE: can we just add parents and not remove?
    @drive.update_file(
      copied_file.id,
      Google::Apis::DriveV3::File.new(name: new_file_name),
      add_parents: destination_id,
      remove_parents: origin_id,
      fields: 'webViewLink'
    )
  end

  private

  def files(name:, parent_id: nil)
    q = "name = '#{name}'"
    q += " and '#{parent_id}' in parents" if parent_id.present?
    @drive.list_files(q:, fields: 'files(id, parents)').files
  end

  def destination_directory_id(path:)
    directory_ids = []

    path.each do |directory_name|
      parent_id = directory_ids.last
      directory = files(name: directory_name, parent_id:).first
      directory_ids.push(directory.id)
    end

    directory_ids.last
  end
end
