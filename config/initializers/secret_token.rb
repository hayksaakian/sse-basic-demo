# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Sse::Application.config.secret_key_base = 'dfaa099e00e8a93386bb6380fcad728f0470f4e156e7cb24463654fb86037bcfd0e24c41309bf1d6a0ca1e1068f657e285bd40f521e444dd25def19df5f53043'
