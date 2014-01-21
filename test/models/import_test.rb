require 'test_helper'

class ImportTest < ActiveSupport::TestCase
  setup do
    imports(:one).file.store!(File.open("test/fixtures/files/adwords.csv"))
  end

  test "requires file" do
    import = Import.new
    import.valid?
    assert_equal ["can't be blank"], import.errors[:file]
  end

  test "#to_s returns name" do
    assert_equal "Adwords CSV Import", imports(:one).to_s
  end

  test "#processed? returns true if processed date exists" do
    refute imports(:one).processed?
    imports(:one).process!
    assert imports(:one).processed?
  end

  test "#first_line returns the first line of the imported file" do
    first_line = ["Ad report (Nov 1, 2013-Nov 30, 2013)", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    assert_equal first_line, imports(:one).first_line
  end

  test "#preview returns the first 10 lines of the imported file" do
    last_line = ["Total", " --", " --", " --", " --", " --", " --", " --", " --", " --", " --", " --", " --", "224", "5265", "4.2500%", "0.78", "175.5", "2.7", "1", "175.5", "0.4500%", "0"]
    assert_equal 10, imports(:one).preview.length
    assert_equal last_line, imports(:one).preview.last
  end

  test "#file_name returns the imported file name" do
    assert_equal "adwords.csv", imports(:one).file_name
  end

  test "#first_date returns earliest date found in file" do
    imports(:one).process!
    assert_equal DateTime.parse("2014-01-01 00:00:00 PST -08:00"), imports(:one).first_date
  end

  test "#last_date returns latest date found in file" do
    imports(:one).process!
    assert_equal DateTime.parse("2014-01-04 00:00:00 PST -08:00"), imports(:one).last_date
  end

  test "#total returns total costs" do
    imports(:one).process!
    assert_equal 4.49, imports(:one).total
  end
end
