# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
SlugAPI::Application.config.secret_key_base = '33a8f41e78d27ac1b395effb3e4c93654d94462c19cb1448406d2d13b4bdbaec74b6cdb2fa96173df1e3ce96d30ff9ed914c44b21057a1386c8e876defbdae03'

SlugAPI::Application.config.secret_token = ENV['SECRET_TOKEN']

