require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "foreign scope" do
    domestic_org = organizations(:domestic)
    foreign_org = organizations(:foreign)

    assert_equal 0, Organization.foreign.where(id: domestic_org.id).count
    assert_equal 1, Organization.foreign.where(id: foreign_org.id).count
  end
end
