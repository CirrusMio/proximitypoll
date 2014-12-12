require 'mail'
#Input UUID@Time@Key
dataInIs = "22022@121120141632@AKey"


#Parse input data
uuid, *rest = dataInIs.split("@")
#stamp, key = rest.split("@")
stamp = rest[0]
key = rest[1]



#Record UUID
open("proximitylog.txt","ab") do |file|
    file << "Date: " + stamp[0] + stamp[1] + "|" + stamp[2] + stamp[3] + "|" + stamp[4] +stamp [5] + stamp[6] + stamp[7]
    file << " Time: " + stamp[8] + stamp[9] + "|" + stamp[10] + stamp[11]
    file << "\nUUID: " + uuid + "\n\n"
end





#Find if user is listed
#Find "{" + uuid + "}" in userlist.txt
*userdata = []
open("userlist.txt","r").each_line do |line|
    if line != "\n"
         temp = line.split("\n")
         userdata << temp[0]
    end
end
#Empty attributes
email = "NONE"
name = "NONE"


#print "Reached userdata\n"
uuid = "[{" + uuid + "}"
userdata.length.times do |i|
    if userdata[i] == uuid
         #print "UUID Validated, i="
         #print i
         #print "\n"
         counter = i
         while userdata[counter] != "]" do
              #Do anything here you want to do with
              #User data
              templine = userdata[counter]
              #print "Line:" + templine + "\n"
              #curl stuff
              if templine[0] == ">"
                   templine = templine.split(">")
                   #print templine[0] + " <- | -> " + templine[1] + "\n"
                   tsplit = templine[1].split(" ")
                   #tsplit << " "
                   if tsplit[0] == "--data"
                        system("curl", tsplit[0], tsplit[1], tsplit[2])
                   else
                        system("curl", tsplit[0])
                   end
                   #curl templine[1]
                   #print templine[1]
              end
              #Split attribute
              #print "\n"
              #print templine
              #print "\n"
              if templine[0] == "@"
                   templine = templine.split(":")
              end
              #print templine
              if templine[0] == "@name"
                   name = templine[1]
              end

              if templine[0] == "@email"
                   email = templine[1]
              end
              #split line by :  (Pseudocode for attributes)
              #If [0] split == attribute type
                     #typeVar = split[1]
              counter = counter + 1
         end
    end
end


############
#print "\n" + name + " | " + email + "\n"
if name != "NONE"
     if email != "NONE"
          print "Attempted to send email\n"

          #Email a user the log if their email and name are provided
          options = { :address              => "smtp.gmail.com",
                      :port                 => 587,
                      :domain               => 'gmail.com',
                      :user_name            => 'cirrusmioat',
                      :password             => 'soserious',
                      :authentication       => 'plain',
                      :enable_starttls_auto => true }

          Mail.defaults do
               delivery_method :smtp, options
          end

          Mail.deliver do
                 to email
                 from 'cirrusmioat@gmail.com'
                 subject 'Proximity Poll Alert for ' + name
                 body ' '
                 attachments['proximitylog.txt'] = File.read('proximitylog.txt')

          end
     end
end

#Test our data files interpretation
open("testwhat.txt","wb") do |file|
    file << userdata
end