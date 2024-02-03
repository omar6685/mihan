require "test_helper"

class MihansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mihan = mihans(:one)
  end

  test "should get index" do
    get mihans_url
    assert_response :success
  end

  test "should get new" do
    get new_mihan_url
    assert_response :success
  end

  test "should create mihan" do
    assert_difference("Mihan.count") do
      post mihans_url, params: { mihan: { foreigners_in_excel_not_in_csv: @mihan.foreigners_in_excel_not_in_csv, foreigners_without_residence: @mihan.foreigners_without_residence, saudis_in_both_files_half: @mihan.saudis_in_both_files_half, saudis_in_both_files_zero: @mihan.saudis_in_both_files_zero, saudis_in_excel_not_in_csv: @mihan.saudis_in_excel_not_in_csv, saudis_only_in_csv: @mihan.saudis_only_in_csv } }
    end

    assert_redirected_to mihan_url(Mihan.last)
  end

  test "should show mihan" do
    get mihan_url(@mihan)
    assert_response :success
  end

  test "should get edit" do
    get edit_mihan_url(@mihan)
    assert_response :success
  end

  test "should update mihan" do
    patch mihan_url(@mihan), params: { mihan: { foreigners_in_excel_not_in_csv: @mihan.foreigners_in_excel_not_in_csv, foreigners_without_residence: @mihan.foreigners_without_residence, saudis_in_both_files_half: @mihan.saudis_in_both_files_half, saudis_in_both_files_zero: @mihan.saudis_in_both_files_zero, saudis_in_excel_not_in_csv: @mihan.saudis_in_excel_not_in_csv, saudis_only_in_csv: @mihan.saudis_only_in_csv } }
    assert_redirected_to mihan_url(@mihan)
  end

  test "should destroy mihan" do
    assert_difference("Mihan.count", -1) do
      delete mihan_url(@mihan)
    end

    assert_redirected_to mihans_url
  end
end
