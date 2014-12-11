#Input UUID@Time@Key
dataInIs = "12345@121120141632@AKey"

#Parse input data
uuid, *rest = dataInIs.split("@")
stamp, key = rest.split("@")


#Record UUID
open("proximitylog","ab") do |file|
    file << stamp
    file << uuid
end





#Find if user is listed





#Output listed user requests