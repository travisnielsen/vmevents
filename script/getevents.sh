#!/bin/bash
events=$(curl -H Metadata:true http://169.254.169.254/metadata/scheduledevents?api-version=2017-08-01)

# Sample JSON for testing when an event exists
# events='{"DocumentIncarnation":0,"Events":[ { "EventId": "123", "EventType": "Redeploy", "ResourceType": "VirtualMachine", "ResourceName": "vm1234", "EventStatus": "Scheduled" } ] }'

# Sample JSON for an empty result (no events)
# events='{"DocumentIncarnation":0,"Events":[]}'

logger "getevents.sh: $events"
eventCount=$(grep -ci '\[\]' <<< $events)

if (( $eventCount < 1 )); then
    logger "vmevents.sh Sending event data to Azure Function"
    curl -H "Content-Type:application/json" --data "$events" https://[your_function_app_name].azurewebsites.net/api/SendEmail?code=[your_function_authentication_code]

    # EXEUCTE YOUR APPLICATION STEPS HERE

fi