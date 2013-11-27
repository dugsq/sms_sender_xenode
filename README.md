sms-sender-xenode
=================

**SMS Sender Xenode** reads its input message context and data, and sends the input message as SMS message through your Twilio account. It leverages the "twilio-ruby" Ruby Gem to perform the SMS send operations. The Xenode will read the sender and recipient information from the configuration properties, and the SMS message content from the input message data. 

###Configuration file options:###
* loop_delay: defines number of seconds the Xenode waits before running process(). Expects a float.
* enabled: determines if the xenode process is allowed to run. Expects true/false.
* debug: enables extra logging messages in the log file. Expects true/false.
* mode: specifies test or production mode for your sms send operations. Expects test/prod.
* account_sid: specifies your Twilio account SID. Expects a string.
* auth_token: specifies your Twilio authorization token. Expects a string.
* default_from: specifies your Twilio phone number. Expects a string.
* default_to: specifies the SMS recipient phone number. Expects a string.

###Example Configuration File:###
* enabled: false
* loop_delay: 30
* debug: false
* mode: test
* test_creds:
    - account_sid: ABCDE12345
    - auth_token: abcde12345
    - default_from: +1234567890
    - default_to: +19876543210
* prod_creds:
    - account_sid: ABCDE12345
    - auth_token: abcde12345
    - default_from: +1234567890
    - default_to: +19876543210

###Example Input:###
* msg.data:  "This string contains the actual text of the SMS to be sent."

###Example Output:###
* The SMS Sender Xenode does not generate any output.  
