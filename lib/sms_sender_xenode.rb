# Copyright Nodally Technologies Inc. 2013
# Licensed under the Open Software License version 3.0
# http://opensource.org/licenses/OSL-3.0

# 
# @version 0.1.0
#
# SMS Sender Xenode reads its input message context and data, and sends the input message as SMS message through your 
# Twilio account. It leverages the "twilio-ruby" Ruby Gem to perform the SMS send operations. The Xenode will read the 
# sender and recipient information from the configuration properties, and the SMS message content from the input message data. 
#
# Config file options:
#   loop_delay:         Expected value: a float. Defines number of seconds the Xenode waits before running process(). 
#   enabled:            Expected value: true/false. Determines if the xenode process is allowed to run.
#   debug:              Expected value: true/false. Enables extra logging messages in the log file.
#   mode:               Expected value: test/prod. Specifies test or production mode for your sms send operations.
#   account_sid         Expected value: a string. Specifies your Twilio account SID.
#   auth_token          Expected value: a string. Specifies your Twilio authorization token.
#   default_from        Expected value: a string. Specifies the SMS sender phone number.
#   default_to          Expected value: a string. Specifies the SMS recipient phone number.
#
# Example Configuration File:
#   enabled: false
#   loop_delay: 30
#   debug: false
#   mode: test
#   test_creds:
#     account_sid: ABCDE12345
#     auth_token: abcde12345
#     default_from: +1234567890
#     default_to: +19876543210
#   prod_creds:
#     account_sid: ABCDE12345
#     auth_token: abcde12345
#     default_from: +1234567890
#     default_to: +19876543210
#
# Example Input:      
#   msg.data:  "This string contains the actual text of the SMS to be sent."
#
# Example Output:   The SMS Sender Xenode does not generate any output.  
#

require 'twilio-ruby'

class SmsSenderXenode
  include XenoCore::NodeBase
  
  def startup
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
    
    begin
      
      cfg = nil
      
      if @config[:mode] && @config[:mode].downcase == 'test'
        # get test mode credentials
        cfg = @config[:test_creds]
      else
        # get regular credentials
        cfg = @config[:prod_creds]
      end
      
      if cfg
        @acct_sid     = cfg[:account_sid]
        @auth_token   = cfg[:auth_token]
        @default_from = cfg[:default_from]
        @default_to   = cfg[:default_to]
      else
        do_debug("#{mctx} - could not parse config.yml #{@config.inspect}")
      end
      
    rescue Exception => e
      catch_error("#{mctx} - #{e.inspect} #{e.backtrace}")
    end
  end
  
  def process_message(msg_in)
    mctx = "#{self.class}.#{__method__} - [#{@xenode_id}]"
    
    begin
      
      if msg_in
        if msg_in.context && msg_in.context[:sms_to]
          # TODO: send to numbers in message context
        else
          client = Twilio::REST::Client.new @acct_sid, @auth_token
          sms_msg = client.account.sms.messages.create(
            :body => msg_in.data, 
            :to   => @default_to, 
            :from => @default_from
          )
          do_debug("#{mctx} - sent sms: #{sms_msg.body} to #{@default_to.inspect} from: #{@default_from.inspect}", true)
        end
      end
      
    rescue Exception => e
      catch_error("#{mctx} - #{e.inspect} #{e.backtrace}")
    end
  end
end