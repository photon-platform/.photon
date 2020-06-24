#!/usr/bin/env bash


# copy from https://gist.github.com/irazasyed/a7b0a079e7727a4315b9

##### run with sudo

# PATH TO YOUR HOSTS FILE
export HOSTS_FILE=/etc/hosts

# DEFAULT IP FOR HOSTNAME
export IP="127.0.0.1"



removehost() {
  if [ $1 ]
  then
    HOSTNAME="$1.local"
    echo "removing host: $HOSTNAME";
    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
    then
        echo "$HOSTNAME Found in your $HOSTS_FILE, Removing now...";
        sudo sed -i".bak" "/$HOSTNAME/d" $HOSTS_FILE
        cat $HOSTS_FILE
    else
        echo "$HOSTNAME was not found in your $HOSTS_FILE";
    fi
  else
    echo "specify project name: removehost my-web"
  fi

}

addhost() {
  if [ $1 ]
  then
    HOSTNAME="$1.local"
    HOSTS_LINE="$IP\t$HOSTNAME"
    echo "checking host: $HOSTNAME";
    if [ -n "$(grep $HOSTNAME $HOSTS_FILE)" ]
        then
            echo "$HOSTNAME already exists : $(grep $HOSTNAME $HOSTS_FILE)"
        else
            echo "Adding $HOSTNAME to your $HOSTS_FILE";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> $HOSTS_FILE";

            if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
                then
                    echo "$HOSTNAME was added succesfully \n $(grep $HOSTNAME $HOSTS_FILE)";
                else
                    echo "Failed to Add $HOSTNAME, Try again!";
            fi
    fi
    cat $HOSTS_FILE
  else
    echo "specify project name: addhost my-web"
  fi

}
