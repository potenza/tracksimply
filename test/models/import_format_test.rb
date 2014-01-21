require 'test_helper'

class ImportFormatTest < ActiveSupport::TestCase
  setup do
    @import_format = ImportFormat.new
  end

  test "requires file type" do
    @import_format.valid?
    assert_equal ["can't be blank"], @import_format.errors[:file_type]
  end

  test "requires date column" do
    @import_format.valid?
    assert_equal ["can't be blank"], @import_format.errors[:date_column]
  end

  test "requires url column" do
    @import_format.valid?
    assert_equal ["can't be blank"], @import_format.errors[:url_column]
  end

  test "requires cost column" do
    @import_format.valid?
    assert_equal ["can't be blank"], @import_format.errors[:cost_column]
  end
end
