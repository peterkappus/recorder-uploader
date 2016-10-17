# Recorder Uploader

A simple script to record and upload music to soundcloud.

## Dependencies

### Chromedriver
If you don't have it already, download the [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/downloads). Unzip, and move the executable somewhere in your path. For example:

`mv ~/Downloads/chromedriver /usr/local/bin`

### Sox
Install [sox](http://sox.sourceforge.net/). For OSX (with brew) you can run:

`brew install sox --with-lame --with-flac --with-libvorbis`

## .env file
`cp sample.env .env`
Then customise .env with your username and password

## Why u no use API?
This is easier and just as safe as long as you don't mind storing your password in cleartext in your .env file :) 

