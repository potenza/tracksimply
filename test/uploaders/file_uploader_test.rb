class FileUploaderTest < ActiveSupport::TestCase
  setup do
    @uploader = FileUploader.new(imports(:one), :file)
    @uploader.store!(File.open("test/fixtures/files/adwords.csv"))
  end

  test "#store_dir return file path" do
    assert_match /uploads\/import\/file\/[0-9]+/, @uploader.store_dir
  end

  test "#extension_white_list only accepts CSV files" do
    assert_equal ['csv'], @uploader.extension_white_list
  end
end
