#This is the ruby file that contains the code that is run when call is made to the port

#List our required libraries
require 'mail'
require_relative '../lib/authentication.rb'

#Define our InProximity class for Sinatra to use
class InProximity < Sinatra::Base
  #Include authentication
  include Authentication

  #Check authentication (NYI)
  before '/poll/*' do
    if authenticate(params[:token])
    else
      halt 403, haml('Access Denied')
    end
  end

  #Proceed with action
  poll = lambda do
                #Input UUID@Time@Key from curl
                #dataInIs = "msg=22022@121120141632@AKey" demo key
                dataInIs = params[:msg]
                #Parse input data
                uuid, *rest = dataInIs.split("@")
                stamp = rest[0]
                key = rest[1]


		#######################################
                #Record UUID
		#Open the log file and write the data
                open("proximitylog.txt","ab") do |file|
                        file << "Date: " + stamp[0] + stamp[1] + "|" + stamp[2]+ stamp[3] + "|" + stamp[4] +stamp [5] + stamp[6] + stamp[7]
                        file << " Time: " + stamp[8] + stamp[9] + "|" + stamp[10] + stamp[11]
                        file << "\nUUID: " + uuid + "\n\n"
                end




		#######################################
                #Find if user is listed in userlist.txt
		#Create blank array then read in each valid line
		#	and strip new lines
                *userdata = []
                open("userlist.txt","r").each_line do |line|
                        if line != "\n"
                                 temp = line.split("\n")
                                 userdata << temp[0]
                        end
                end

                #Initialize Empty attributes here
		#Attribute = trait
                email = "NONE"
                name = "NONE"


                #Format the UUID according to user file
                uuid = "[{" + uuid + "}"

		#Iterate through user data and keep track of position in data
                userdata.length.times do |i|
			#If the current data matches the user ID
                        if userdata[i] == uuid
                                 #Then set counter to current position and read in user information
				 #	until the end marker is found
                                 counter = i
                                 while userdata[counter] != "]" do
					  #Find if the line is an application call
                                          templine = userdata[counter]
                                          #If so then curl stuff
                                          if templine[0] == ">"
						   #Format the curl call
                                                   templine = templine.split(">")
                                                   tsplit = templine[1].split(" ")
                                                   #If data or else no data
                                                   if tsplit[0] == "--data"
                                                                system("curl", tsplit[0], tsplit[1], tsplit[2])
                                                   else
                                                                system("curl", tsplit[0])
                                                   end
                                          end
					  #Otherwise, if it is an attribute definition split it. attr < : > trait
                                          if templine[0] == "@"
                                                   templine = templine.split(":")
                                          end
                                          #If left hand is name then right hand is value
                                          if templine[0] == "@name"
                                                   name = templine[1]
                                          end
					
					  #If left hand is email then right hand is value
                                          if templine[0] == "@email"
                                                   email = templine[1]
                                          end
                                          #split line by :  (Pseudocode for attributes)
                                          #If [0] split == attribute type
                                                         #typeVar = split[1]
					  #More variables can be added easily here but must be added after curls
					  #Increment position counter
                                          counter = counter + 1
                                 end
                        end
                end


                ##########################################
		#Actions:
                #If an email and name attribute were found
                if name != "NONE"
                         if email != "NONE"
                                  #Email a user the log if their email and name are provided
				  #Sets SMTP options
                                  options = { :address              => "smtp.gmail.com",
                                                          :port	=> 587,
                                                          :domain	=> 'gmail.com',
                                                          :user_name	=> 'cirrusmioat',
                                                          :password	=> 'soserious',
                                                          :authentication	=> 'plain',
                                                          :enable_starttls_auto	=> true }
				  #Apply options
                                  Mail.defaults do
                                           delivery_method :smtp, options
                                  end
				  #Deliver msg
                                  Mail.deliver do
                                                 to email
                                                 from 'cirrusmioat@gmail.com'
                                                 subject 'Proximity Poll Alert for ' + name
                                                 body ' '
                                                 attachments['proximitylog.txt'] = File.read('proximitylog.txt')

                                  end
                         end
                end
        end
  end
   #Get and post poll
   get '/poll', &poll
   post '/poll', &poll

end