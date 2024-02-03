require "application_system_test_case"

class MihansTest < ApplicationSystemTestCase
  setup do
    @mihan = mihans(:one)
  end

  test "visiting the index" do
    visit mihans_url
    assert_selector "h1", text: "Mihans"
  end

  test "should create mihan" do
    visit mihans_url
    click_on "New mihan"

    fill_in "Foreigners in excel not in csv", with: @mihan.foreigners_in_excel_not_in_csv
    fill_in "Foreigners without residence", with: @mihan.foreigners_without_residence
    fill_in "Saudis in both files half", with: @mihan.saudis_in_both_files_half
    fill_in "Saudis in both files zero", with: @mihan.saudis_in_both_files_zero
    fill_in "Saudis in excel not in csv", with: @mihan.saudis_in_excel_not_in_csv
    fill_in "Saudis only in csv", with: @mihan.saudis_only_in_csv
    click_on "Create Mihan"

    assert_text "Mihan was successfully created"
    click_on "Back"
  end

  test "should update Mihan" do
    visit mihan_url(@mihan)
    click_on "Edit this mihan", match: :first

    fill_in "Foreigners in excel not in csv", with: @mihan.foreigners_in_excel_not_in_csv
    fill_in "Foreigners without residence", with: @mihan.foreigners_without_residence
    fill_in "Saudis in both files half", with: @mihan.saudis_in_both_files_half
    fill_in "Saudis in both files zero", with: @mihan.saudis_in_both_files_zero
    fill_in "Saudis in excel not in csv", with: @mihan.saudis_in_excel_not_in_csv
    fill_in "Saudis only in csv", with: @mihan.saudis_only_in_csv
    click_on "Update Mihan"

    assert_text "Mihan was successfully updated"
    click_on "Back"
  end

  test "should destroy Mihan" do
    visit mihan_url(@mihan)
    click_on "Destroy this mihan", match: :first

    assert_text "Mihan was successfully destroyed"
  end
end
