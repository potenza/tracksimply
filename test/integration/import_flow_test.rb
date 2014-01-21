require "integration_test_helper"

class ImportFlowTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
    click_on "My Site", match: :first
    click_on "Cost Imports"
  end

  test "new import" do
    click_on "New Import"
    attach_file "File", "test/fixtures/files/adwords.csv"
    click_on "Upload File"

    fill_in "File type", with: "Adwords CSV"
    select "Date", from: "_columns_0"
    select "Destination URL", from: "_columns_6"
    select "Cost", from: "_columns_17"
    click_on "Save Format"

    assert_page_has_content page, "This file is being processed"
  end

  test "delete import" do
    import = Import.first
    import.file.store!(File.open("test/fixtures/files/adwords.csv"))
    import.process!

    click_on "Adwords CSV Import"
    click_on "Delete Import"

    assert_page_has_content page, "Import deleted"
  end

  test "delete import formats" do
    click_on "Import Formats"
    click_on "Delete"

    assert_page_has_content page, "Import Format deleted"
  end
end
