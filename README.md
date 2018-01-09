# Azure VM Events Demo
This demonstration consists of two parts: (1) an endpoint (API) that receives event data from VMs and sends an email notification to a designated administrator and (2) a script running on each virtual machine that queries its local metadata endpoint for new events on a scheduled basis and relays any detected event to the API.

The email integration in this demo uses [SendGrid](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/SendGrid.SendGrid) and you must have a SendGrid account to complete the setup steps. This demo was tested using SendGrid's free tier offering.

## Create a SendGrid API key
As a pre-requisite we must first configure an API key for our VM event endpoint. From the Azure Portal, use the search bar and type "SendGrid" and then select **SendGrid Accounts**. On the next page, you will be able to click your specific SendGrid account. In the middle page, you will see an icon labeled **Manage**. After clicking that icon a new tab will open for the SendGrid portal.

From the SendGrid Portal, click **Account Details**. You will see a link for **API Keys** in the lower left-hand corner. Click the **Create API Key** button in the upper right-hand corner. Give the key a name and select **Restricted Access**. Grant the **Mail Send** permission to the key and leave everything else with no access. When finished, copy the value of the key. You will need it in the next section.

## Cloud Endpoint (Azure Function)
This is implemented as a simple Azure Function. Open the Azure Portal in your browser and navigate to **App Services**. Click **Add** and then select **Function App**. Fill in the resource group and consumption plan information on the create page and then click **Create**. Shortly after this, you will see the new Function App in your list of available App Services.

### Set the runtime version on the Function App
Before creating the function, you must first upgrade the Function App to the latest runtime version. To do this, highlight the Function App and select **Platform Features** and then **Function app settings**. In the **Runtime version** section, select **beta**. The Function App will then switch to the new runtime.

### Configure the SendGrid API Key App Setting
From the **Overview** tab of the Function App, click **Application Settings**. Click **Add new setting** and name it **SENDGRID_API_KEY**. Copy and paste the SendGrid API key here.

### Create the function
With the Function App highlighted, navigate to **Functions** and click the **New function** button. Choose **HTTP trigger**, set the language to **C#**, name it **SendEmail**, and set the authorization level to **Function**. Click **Create** when done.

### Add the SendGrid output binding
Under the new function, click the **Integrate** section and then select **New Output** on the right-side of the screen. At the next window, select **SendGrid** and then click the **Select** button. You will then see a new dialogue stating an extension needs to be installed. Click **Install** so the pre-requisite libraries are made available to the function code.

At the lower half of the screen, update the value of **Message parameter name** to **messages** (with an 's' at the end) and populate **From address** and **To address**. Finally, use the dropdown in **SendGrid API Key App Setting** to select the App Setting you configured earlier. Click **Save** when finished.

### Add the function code
Select the **SendMail** function and copy-and-pate the code located in [run.csx](https://github.com/travisnielsen/vmevents/blob/master/function/run.csx).

### Get the function URL
The final step is to document the function URL. The script in the next section will need to be updated to match your environment. To get the URL, select the **SendMail** function and click the **Get function URL** link in the upper right corner. Save this value for the next section.

## Script (Linux)
Checking for scheduled VM events is handled by a systemd timer job that executes [getevents.sh](https://github.com/travisnielsen/vmevents/blob/master/script/getevents.sh) every 5 minutes. It has been tested on RHEL 7.4 and should work on most systems that support systemd. To deploy it, download and execute [setup.sh](https://github.com/travisnielsen/vmevents/blob/master/script/setup.sh) as follows:

```
curl -o setup.sh  https://raw.githubusercontent.com/travisnielsen/vmevents/master/script/setup.sh
sudo setup.sh
```

Execution of the script can be seen in syslog by running `sudo cat /var/log/messages`

If necessary, execution frequency can be modified by editing the [OnCalendar setting](https://github.com/travisnielsen/vmevents/blob/master/script/vmevents.timer#L5) in `/usr/lib/systemd/system/vmevents.timer`

As mentioned earlier, you will need to update [getevents.sh](https://github.com/travisnielsen/vmevents/blob/master/script/getevents.sh#L15) to match the URL and authentication code of your specific environment.