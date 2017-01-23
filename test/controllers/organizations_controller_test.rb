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
      org = orgs.select{|o| o['id'] == db_org.id}.first
      assert_equal db_org.id, org['id']
      assert_equal db_org.name, org['name']
      assert_equal db_org.created_at.to_json.gsub('"', ''), org['created_at']
      assert_equal db_org.updated_at.to_json.gsub('"', ''), org['updated_at']
    end
  end

  test "should create organization" do
    assert_difference('Organization.count') do
      post organizations_url, params: { organization: { name: "New Org" } }, as: :json
    end

    assert_response 201

    org = JSON.parse(response.body)
    assert org['id'].present?
    assert_equal "New Org", org['name']
    assert org['created_at'].present?
    assert org['updated_at'].present?
  end

  test "should show organization" do
    get organization_url(@organization), as: :json
    assert_response :success

    org = JSON.parse(response.body)
    assert_equal @organization.id, org['id']
    assert_equal @organization.name, org['name']
    assert_equal @organization.created_at.to_json.gsub('"', ''), org['created_at']
    assert_equal @organization.updated_at.to_json.gsub('"', ''), org['updated_at']
  end

  test "should update organization" do
    patch organization_url(@organization), params: { organization: { name: "Updated Org" } }, as: :json
    assert_response 200

    org = JSON.parse(response.body)
    assert_equal @organization.id, org['id']
    assert_equal "Updated Org", org['name']
  end

  test "should destroy organization" do
    event_count = @organization.events.count
    assert(event_count > 0)
    assert_difference('Organization.count', -1) do
      assert_difference('Event.count', -event_count) do
        delete organization_url(@organization), as: :json
      end
    end

    assert_response 204
  end
end
