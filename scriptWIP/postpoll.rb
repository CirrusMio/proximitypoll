#require string
#Input UUID@Time@Key
dataInIs = "12345@121120141632@AKey"

#Parse input data
uuid, *rest = dataInIs.split("@")
#stamp, key = rest.split("@")
stamp = rest[0]
key = rest[1]
#stamp="$(echo "$@" | sed 's/ /\+/g')"

#Record UUID
open("proximitylog.txt","ab") do |file|
    file << "Date: " + stamp[0] + stamp[1] + "|" + stamp[2] + stamp[3] + "|" + s
tamp[4] +stamp [5] + stamp[6] + stamp[7]
    file << " Time: " + stamp[8] + stamp[9] + "|" + stamp[10] + stamp[11]
    file << "\nUUID: " + uuid + "\n\n"
end





#Find if user is listed





#Output listed user requests
