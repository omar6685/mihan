require "test_helper"

class MihanMowatansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mihan_mowatan = mihan_mowatans(:one)
  end

  test "should get index" do
    get mihan_mowatans_url
    assert_response :success
  end

  test "should get new" do
    get new_mihan_mowatan_url
    assert_response :success
  end

  test "should create mihan_mowatan" do
    assert_difference("MihanMowatan.count") do
      post mihan_mowatans_url, params: { mihan_mowatan: { company_name: @mihan_mowatan.company_name, result: @mihan_mowatan.result } }
    end

    assert_redirected_to mihan_mowatan_url(MihanMowatan.last)
  end

  test "should show mihan_mowatan" do
    get mihan_mowatan_url(@mihan_mowatan)
    assert_response :success
  end

  test "should get edit" do
    get edit_mihan_mowatan_url(@mihan_mowatan)
    assert_response :success
  end

  test "should update mihan_mowatan" do
    patch mihan_mowatan_url(@mihan_mowatan), params: { mihan_mowatan: { company_name: @mihan_mowatan.company_name, result: @mihan_mowatan.result } }
    assert_redirected_to mihan_mowatan_url(@mihan_mowatan)
  end

  test "should destroy mihan_mowatan" do
    assert_difference("MihanMowatan.count", -1) do
      delete mihan_mowatan_url(@mihan_mowatan)
    end

    assert_redirected_to mihan_mowatans_url
  end
end
