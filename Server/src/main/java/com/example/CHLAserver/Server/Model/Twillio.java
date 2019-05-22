package com.example.CHLAserver.Server.Model;

import com.twilio.sdk.TwilioRestClient;
import com.twilio.sdk.TwilioRestException;
import com.twilio.sdk.resource.factory.MessageFactory;
import com.twilio.sdk.resource.instance.Message;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

public class Twillio {

    private static Logger log = LoggerFactory.getLogger(Twillio.class);
    private static final String ACCOUNT_SID = "ACe6274305c04d3c304fda8f3c9ee96f41";
    private static final String AUTH_TOKEN = "9970b693a54501d5bbba2e9bdce14b5a";
    private static final String TWILIO_NUMBER = "+13312561975";
    //public static final String MSG_PRESET = "Thank you for dropping your car at CHLA - Valet, To get your car back from the Valet. ";

    public static void sendSMS(String msg,String number) {
        try {
            TwilioRestClient client = new TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN);
            // Build a filter for the MessageList
            List<NameValuePair> params = new ArrayList<NameValuePair>();
            params.add(new BasicNameValuePair("Body", msg));
            params.add(new BasicNameValuePair("To", "+1"+number)); //Add real number here
            params.add(new BasicNameValuePair("From", TWILIO_NUMBER));

            MessageFactory messageFactory = client.getAccount().getMessageFactory();
            Message message = messageFactory.create(params);
            log.info("Message sent with message id: " + message.getSid());
        }
        catch (TwilioRestException e) {
            System.out.println(e.getErrorMessage());
        }
    }

}