require 'json'

# Assuming a file "path/to/aws_secrets.json" with contents like:
#
#     { "AccessKeyId": "YOUR_KEY_ID", "SecretAccessKey": "YOUR_ACCESS_KEY" }
#
# Remember to exclude "path/to/aws_secrets.json" from version control, e.g. by
# adding it to .gitignore
# secrets = JSON.load(File.read('path/to/aws_secrets.json'))

creds = Aws::Credentials.new('AKIAIWSIP6LDPA3Q7V2Q', '219j/aqGxvwv6NHiVWZ8+3TC9xzilvkqLsy98Xeh')
Aws::Rails.add_action_mailer_delivery_method(:aws_sdk, credentials: creds, region: 'us-west-2')