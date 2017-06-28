
require 'capybara/dsl'
require 'dotenv'
Dotenv.load

#setup some globals for later... messy but whateves
@title = Time.now.strftime("%Y-%m-%d") + " Piano Improvisation"
@hifi_file = File.expand_path(File.dirname(__FILE__)) + "/" + Time.now.strftime("%Y-%m-%d") + ".flac"
@file = File.expand_path(File.dirname(__FILE__)) + "/" + Time.now.strftime("%Y-%m-%d") + ".mp3"

def record()
  #first record a flac file
  rec_cmd = "rec #{@hifi_file} silence 1 0:01 0.00599% 1 0:03 0.00599% norm compand 0.3,1 -5,-5"
  system(rec_cmd)
  
  #now convert to MP3
  system("sox #{@hifi_file} #{@file}")
  
  #IO.popen(rec_cmd)
end

def upload(file, title)
  include Capybara::DSL

  #register the chrome driver
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  Capybara.default_driver = :chrome

  visit "http://soundcloud.com/signin"
  fill_in "username", :with=>ENV['SOUNDCLOUD_USERNAME']
  click_on "Continue"
  sleep 1
  fill_in "password", :with=>ENV['SOUNDCLOUD_PASSWORD']
  sleep 2
  find_all("button", :text=>"Sign in")[1].click
  sleep 2
  visit "http://soundcloud.com/upload"
  #click_on "Choose a file to upload"
  find("input",:class=>"chooseFiles__input").set(file)
  sleep 1
  find_all("input")[2].set(title)
  click_on "None"
  click_on "Piano"
  #Capybara.default_wait_time = 30
  #wait for upload to complete... is there a better way to do this?
  #maybe search for a completion notification and then move on?
  #previously the script was ending before the upload was complete...
  sleep 60
  click_on "Save"
  sleep 30
  click_on "Go to your track"
end

#our main program

puts "Press play on your keyboard within 3 seconds. Recording will stop automatically after 3 seconds of silence."
record
#puts "\n\nPress enter when finished recording.\n\n"
#gets

#wait for our file to show up (weird hack since the recorder is running in a thread outside the main thread
# can't remember why I had to use IO.popen instead of exec or backticks...
#until File.exists? @file do
#  sleep 2
#end
upload @file, @title
