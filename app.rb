
require 'capybara/dsl'
require 'dotenv'
Dotenv.load

#setup some globals for later... messy but whateves
@title = Time.now.strftime("%Y-%m-%d") + " Piano Improvisation"
@file = File.expand_path(File.dirname(__FILE__)) + "/" + Time.now.strftime("%Y-%m-%d") + ".mp3"

def record()
  rec_cmd = "rec #{@file} silence 1 0:01 0.00599% 1 0:03 0.00599% norm compand 0.3,1 -5,-5"
  IO.popen(rec_cmd)
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
  sleep 60
  click_on "Save"
  sleep 30
  click_on "Go to your track"
end

#our main program

record
puts "\n\nPress enter when finished recording.\n\n"
gets
upload @file, @title
