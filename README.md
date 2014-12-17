proximitypoll
=============

## Contributing

So you've got an awesome idea. Great! Please keep the following in mind:

* Please follow the [GitHub Ruby Styleguide](https://github.com/styleguide/ruby)
  when modifying Ruby code.
* Please do your best to submit **small pull requests**. The easier the proposed
  change is to review, the more likely it will be merged.
* When submitting a pull request, please make judicious use of the pull request
  body. A description of what changes were made, the motivations behind the
  changes and [any tasks completed or left to complete](http://git.io/gfm-tasks)
  will also speed up review time.
* Tests would be nice.

## Running Server

Deamonized Thin

`sudo thin -a 10.0.1.101 -p 80 -R config.ru -d --pid thin.pid start`

### Foreman

**Development**

`foreman start -f Procfile.dev`

**Production**

Foreman can export an init script via the following: bluepill, inittab, runit, upstart

For more info on Foreman export formats see:
http://ddollar.github.io/foreman/#EXPORT-FORMATS

## Getting Started

## Have Proximity Poll record data and call other webhooks from userlist file.

`curl --data "msg=uuid@DDMMYYYY@key" http://127.0.0.1:80/poll`

## Raspberry Pi setup

`sudo apt-get update`

Install git:

`sudo apt-get install git`

Install ruby:

`sudo apt-get install ruby` #=> ruby 1.9.3, ruby 2 would be better

`sudo apt-get install ruby-dev` #=> provides required libraries

Install bundler:

`sudo gem install bundler`

Clone Proximity Poll:

`git clone https://github.com/CirrusMio/proximitypoll.git`

Bundle gems:

`cd /path/to/proximitypoll && sudo bundle install`
       
## How to Use
Once you have everything installed, there are four things you want to configure or at least take note of.
1. Edit / Record the IP/Port Proximity Poll will be listening on. The Procfile.dev will have "-p WXYZ" where WXYZ is the port it will listen on.
2. The default action handler. In handlers/in_proximity.rb you will want to set lines116 and 117 to your preferences. By default it will send an email to itself containing the unknown UUID that triggered it.
3. In the same file as the one above look for lines 127-142. These lines contain the sender smtp information. You may customize these if you wish.
4. The userlist.txt file contains custom e-mail notification settings as well as calls to other devices using curl.
       
## userlist.txt
This file is so important it needs its own section! There are samples in the file in the repo as well.
There are a few conventions to keep in mind while using this file. A user is separated by: 
```sh
    [{uuid}
    ...
    settings
    ...
    ]
```
Any comments or notes may be left outside of the [] and it will not affect the ability to read the file. Variables within a block of user information are formed as follows: 
       @variableName:variableValue
You may specify a custom curl message when the user's UUID is detected by:
    >--data "messages or data goes here" http://localhost:4565/door
The above is a sample that will trigger our related Door Watcher app when the UUID is read in.
A full sample:
```sh
[{10101}
>http://localhost:4565/door
@name:GuyMan
@email:guysboss@gmail.com
>--data "words=Hello+Guy" http://localhost:4567/say
]
```
This sample would call Door Watcher when GuyMan (AKA: 10101) enters the range and then send an email to guysboss@gmail.com and greet him by calling AinsleyTwo.

## Fun ideas!
Use this to track employees, children, hotel residents and more!
Use it for custom greetings!
With iBeacon distance ranges you can have it even change the music for each room you enter.
Custom entertainment settings for each user.

(Much borrowed from AinsleyTwo)