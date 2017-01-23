require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:one)
  end

  test "should get index" do
    get organizations_url, as: :json
    assert_response :success

    orgs = JSON.parse(response.body)
    assert orgs.kind_of?(Array)
    assert_equal Organization.count, orgs.length

    Organization.find_each do |db_org|
      org = orgs.select{|o| o['name'] == db_org.name}.first
      assert_not_nil org
    end
  end

  test "should create organization" do
    assert_difference('Organization.count') do
      post organizations_url, params: { organization: { name: "New Org" } }, as: :json
    end

    assert_response 201

    org = JSON.parse(response.body)
    assert_equal "New Org", org['name']
  end

  test "should show organization" do
    get organization_url(@organization.name), as: :json
    assert_response :success

    org = JSON.parse(response.body)
    assert_equal @organization.name, org['name']
  end

  test "should update organization" do
    patch organization_url(@organization.name), params: { organization: { name: "Updated Org" } }, as: :json
    assert_response 200

    org = JSON.parse(response.body)
    assert_equal "Updated Org", org['name']
  end

  test "should destroy organization" do
    event_count = @organization.events.count
    assert(event_count > 0)
    assert_difference('Organization.count', -1) do
      assert_difference('Event.count', -event_count) do
        delete organization_url(@organization.name), as: :json
      end
    end

    assert_response 204
  end
end
