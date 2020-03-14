# README

# There are a few notable features in this application.
1. Authentication is custom. Authorization is handled with cancancan.
2. Images/Files are securly handled using send_file and carrierwave.
3. Searches use seperate classes to cut down on code and increase reusability.
4. Attachment Images/Files are uploaded with JS/AJAX using base64.
5. Avatar Images use standard html form uploads.
6. Displayed images have plenty of features including arrangement.
7. RSPEC specs have been created that account for both upload methods.
8. The applicationn has a language selector (non-persistent but easy enough to change).
9. There are js translations that use the rails localization files.
10. This application could be turned into a microservice.
11. Application can connect to slack to send notifications (ENV variable configuration required).

# Installation
###
- Follow this guide for base setup instructions
- https://gorails.com/setup/ubuntu/16.04
- ruby 2.4.0p0 (2016-12-24 revision 57164) [x86_64-linux]
- carrierwave dependencies
  - sudo apt-get install imagemagick libmagickwand-dev
- Current db is psql, but can easily run in sqlite3
- If you want to use sqlite3 uncomment line 14 and comment line 15 in
  - app/models/concerns/filterable.rb
  - and of course adjust the gem file

###
# rbenv environment variables can be used
###
* cd ~/.rbenv/plugins
* git clone https://github.com/sstephenson/rbenv-vars.git
* cd ~/mentel_contacts
* view .rbenv-vars for environment variables
###
# When booting up the application for the first time
* rake db:create db:migrate db:seed
* login with email harry.fairbanks@test.com pw password for admin role
* login with email bob@test.com pw password for business role
###
# Tests
* bundle exec rspec
###
