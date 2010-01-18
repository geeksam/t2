# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_t2_session',
  :secret      => '11c50700861e88042eaee01a423c8e1ff14a2c7121972371f35f7c3a34dd72e58957a008aac5946a20cb4ff36bb8030e452105bfda3988af964b51d31f7ee16e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
