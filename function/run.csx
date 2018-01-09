#r "Newtonsoft.Json"
#r "SendGrid"
using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json; 
using SendGrid.Helpers.Mail;
using System.Text;

public static async Task<IActionResult> Run(HttpRequest req, TraceWriter log, IAsyncCollector<SendGridMessage> messages)
{
    log.Info("Received Scheduled VM Event");

    using (StreamReader reader = new StreamReader(req.Body, Encoding.UTF8))
    {
        var body = await reader.ReadToEndAsync();
        var message = new SendGridMessage();
        message.AddContent("text/html", body);
        message.SetSubject("[Alert] VM Scheduled Event Notrtification");
        await messages.AddAsync(message); 
        return (ActionResult)new OkObjectResult("The E-mail has been sent.");
    }
}