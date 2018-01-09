events=$(curl -H Metadata:true http://169.254.169.254/metadata/scheduledevents?api-version=2017-08-01)

# Sample JSON for testing when an event exists
# events='{"DocumentIncarnation":0,"Events":[ { "EventId": "123", "EventType": "Redeploy", "ResourceType": "VirtualMachine", "ResourceName": "vm1234", "EventStatus": "Scheduled" } ] }'

# Sample JSON for an empty result (no events)
#events='{"DocumentIncarnation":0,"Events":[]}'

echo $events
eventCount=$(grep -ci '\[\]' <<< $events)
echo $eventCount
if (( $eventCount < 1 )); then
    echo "Sending event data to Azure Function"
    curl -H "Content-Type:application/json" --data "$events" https://vmevents.azurewebsites.net/api/SendEmail?code=igtLwOn2t4s69X4mozuh0uWd8i5jXEILOk6kakIQS0qO8IC0rs6j/Q==
fi