#!/bin/sh
runGrive(){    
    while :
    do
      echo "Sync Started!!!"
      grive $PARAMS
      echo "Finished, going to sleep for ${SLEEP:-1} seconds..."
      sleep ${SLEEP:-1}
    done
}
echo "Starting Grive2 Docker..."
if [ -f /drive/.grive ]; then
    echo "Configuration Exists!"
    runGrive
else
    if [ -z "$ID" ]; then
        echo "
                Configuration is missing...
                First Time Setup (Action Required):	
                - Go to https://console.developers.google.com/apis/library. Login with your Google account and create a new project on Google Cloud Platform.
                - Search for Google Drive API and enable it.
                - Go to API Credentials page (https://console.developers.google.com/apis/credentials)
                - Create a new OAuth Client credential. Select TV as device type. You will be provided with a id and a secret. 
                - Save both CLIENT_ID and SECRET because you gonna need it for grive2.
                - Run this container again with these ENV options : 
                                    docker run -it -e ID=YOURID -e SECRET=YOUR_CLIENT_SECRET  -v /mnt/user/appdata/drive:/drive agusalex/grive2 
                - Go to  URL Grant Access then copy and paste code when prompted in the terminal
                - Enjoy the Grive2!! 
                "
    else

        if [ -z "$CODE" ]; then
            echo "Configuration is missing...
                      Starting setup... "
            grive $PARAMS -a --id $ID --secret $SECRET #First run is with params
            runGrive #Then we loop

        else
            echo "Auto-Configuring with provided authCode..."
            echo -ne "$CODE\n" | grive $PARAMS -a --id $ID --secret $SECRET #First run is with params
            runGrive #Then we loop
        fi
    fi
fi
