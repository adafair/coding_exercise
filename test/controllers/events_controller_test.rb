require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    @organization = organizations(:one)
  end

  test "should get index" do
    get events_url, as: :json
    assert_response :success

    events = JSON.parse response.body
    assert events.kind_of?(Array)
    assert(events.length > 0)

    Event.find_each do |db_event|
      event = events.select{|e| e['id'] == db_event.id}.first
      assert_not_nil event
      assert_equal db_event.organization_id, event['organization_id']
      assert_equal db_event.message, event['message']
      assert_equal db_event.hostname, event['hostname']
      assert_equal db_event.created_at.to_json.gsub('"', ''), event['created_at']
      assert_equal db_event.updated_at.to_json.gsub('"', ''), event['updated_at']
    end
  end

  test "should get index for organization" do
    get events_url(organization_id: @organization.name), as: :json
    assert_response :success

    events = JSON.parse response.body
    assert events.kind_of?(Array)
    assert_equal @organization.events.count, events.length

    @organization.events.find_each do |db_event|
      event = events.select{|e| e['id'] == db_event.id}.first
      assert_not_nil event
      assert_equal db_event.organization_id, event['organization_id']
      assert_equal db_event.message, event['message']
      assert_equal db_event.hostname, event['hostname']
      assert_equal db_event.created_at.to_json.gsub('"', ''), event['created_at']
      assert_equal db_event.updated_at.to_json.gsub('"', ''), event['updated_at']
    end
  end

  test "should get index with ten results" do
    get events_url(limit: 10), as: :json
    assert_response :success

    events = JSON.parse response.body
    assert events.kind_of?(Array)
    assert_equal 10, events.length    # Only 10 events should be returned
    assert(Event.count > 10)          # There should be more than 10 events in the database for this test to work

    # The 10 most recent events should be returned
    Event.order("created_at DESC").limit(10).each do |db_event|
      event = events.select{|e| e['id'] == db_event.id}.first
      assert_not_nil event
      assert_equal db_event.organization_id, event['organization_id']
      assert_equal db_event.message, event['message']
      assert_equal db_event.hostname, event['hostname']
      assert_equal db_event.created_at.to_json.gsub('"', ''), event['created_at']
      assert_equal db_event.updated_at.to_json.gsub('"', ''), event['updated_at']
    end
  end

  test "should get index with ten results for organization" do
    db_events = @organization.events

    get events_url(organization_id: @organization.id, limit: 10), as: :json
    assert_response :success

    events = JSON.parse response.body
    assert events.kind_of?(Array)
    assert_equal 10, events.length    # Only 10 events should be returned
    assert(db_events.count > 10)      # There should be more than 10 events in the database for this test to work

    # The 10 most recent events should be returned
    db_events.order("created_at DESC").limit(10).each do |db_event|
      event = events.select{|e| e['id'] == db_event.id}.first
      assert_not_nil event
      assert_equal @organization.id, event['organization_id']
      assert_equal db_event.message, event['message']
      assert_equal db_event.hostname, event['hostname']
      assert_equal db_event.created_at.to_json.gsub('"', ''), event['created_at']
      assert_equal db_event.updated_at.to_json.gsub('"', ''), event['updated_at']
    end
  end

  test "should get index with ten results with a certain hostname for an organization" do
    hostname = "extra-example.org"
    db_events = @organization.events.where(hostname: hostname)

    get events_url(organization_id: @organization.id, limit: 10, hostname: hostname), as: :json
    assert_response :success

    events = JSON.parse response.body
    assert events.kind_of?(Array)
    assert_equal 10, events.length    # Only 10 events should be returned
    assert(db_events.count > 10)      # There should be more than 10 events in the database for this test to work

    # The 10 most recent events should be returned
    db_events.order("created_at DESC").limit(10).each do |db_event|
      event = events.select{|e| e['id'] == db_event.id}.first
      assert_not_nil event
      assert_equal @organization.id, event['organization_id']
      assert_equal db_event.message, event['message']
      assert_equal hostname, event['hostname']
      assert_equal db_event.created_at.to_json.gsub('"', ''), event['created_at']
      assert_equal db_event.updated_at.to_json.gsub('"', ''), event['updated_at']
    end
  end

  test "should create event" do
    assert_difference('Event.count') do
      post(
        organization_events_url(organization_id: @organization.name),
        params: {
          event: { message: "New Event", hostname: "example-1.org" }
        },
        as: :json
      )
    end

    assert_response 201

    event = JSON.parse response.body
    assert_not_nil event
    assert event['id'].present?
    assert_equal @organization.id, event['organization_id']
    assert_equal "New Event", event['message']
    assert_equal "example-1.org", event['hostname']
    assert event['created_at'].present?
    assert event['updated_at'].present?
  end

  test "should show event" do
    get event_url(@event), as: :json
    assert_response :success

    event = JSON.parse response.body
    assert_not_nil event
    assert_equal @event.id, event['id']
    assert_equal @event.organization_id, event['organization_id']
    assert_equal @event.message, event['message']
    assert_equal @event.hostname, event['hostname']
    assert_equal @event.created_at.to_json.gsub('"', ''), event['created_at']
    assert_equal @event.updated_at.to_json.gsub('"', ''), event['updated_at']
  end

  test "should update event" do
    org_id = @event.organization_id

    patch event_url(@event), params: { event: { message: "Updated Event", hostname: "example-2.org" } }, as: :json
    assert_response 200

    event = JSON.parse response.body
    assert_not_nil event
    assert_equal @event.id, event['id']
    assert_equal org_id, event['organization_id']
    assert_equal "Updated Event", event['message']
    assert_equal "example-2.org", event['hostname']
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete event_url(@event), as: :json
    end

    assert_response 204
  end
end
