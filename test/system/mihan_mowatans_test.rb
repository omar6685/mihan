require "application_system_test_case"

class MihanMowatansTest < ApplicationSystemTestCase
  setup do
    @mihan_mowatan = mihan_mowatans(:one)
  end

  test "visiting the index" do
    visit mihan_mowatans_url
    assert_selector "h1", text: "Mihan mowatans"
  end

  test "should create mihan mowatan" do
    visit mihan_mowatans_url
    click_on "New mihan mowatan"

    fill_in "Company name", with: @mihan_mowatan.company_name
    fill_in "Result", with: @mihan_mowatan.result
    click_on "Create Mihan mowatan"

    assert_text "Mihan mowatan was successfully created"
    click_on "Back"
  end

  test "should update Mihan mowatan" do
    visit mihan_mowatan_url(@mihan_mowatan)
    click_on "Edit this mihan mowatan", match: :first

    fill_in "Company name", with: @mihan_mowatan.company_name
    fill_in "Result", with: @mihan_mowatan.result
    click_on "Update Mihan mowatan"

    assert_text "Mihan mowatan was successfully updated"
    click_on "Back"
  end

  test "should destroy Mihan mowatan" do
    visit mihan_mowatan_url(@mihan_mowatan)
    click_on "Destroy this mihan mowatan", match: :first

    assert_text "Mihan mowatan was successfully destroyed"
  end
end
