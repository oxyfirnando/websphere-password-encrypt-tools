#!/bin/bash

path=$(pwd)/..
thank="Thank you!"

echo "WebSphere Password Encoder Tool"
echo "Put this script into WebSphere install_root/bin directory before run it!"
echo
case "$1" in
  "-decode")
    read -p "Please input hash that you want to decode : " hash
    echo
    if [[ ! -z $hash ]]; then
      result=$($path/java/bin/java -Djava.ext.dirs=$path/plugins:$path/lib com.ibm.ws.security.util.PasswordDecoder "$hash")
      echo
      if [[ $result != *ERROR* ]]; then
        echo $result | awk '{split($0,a,","); print a[2]}' | awk '{$1=$1};1'
      else
        echo "seems that hash is using wrong algorithm or already decoded!"
      fi
    else
       echo "You didn't input any hash."
       echo "Plase check again!"
    fi
  ;;
  "")
    read -s -p  "Please enter the password : " password
    echo
    read -s -p "Please re-enter the password : " password1
    echo
    echo

    if [[ (! -z $password) && (! -z $password1) ]]; then
      if [[ $password != $password1 ]]; then
          echo "Passwords not match"
          echo "Please check again!"
      else
          echo "Passwords match, please wait for the encoded password!"
          result=$($path/java/bin/java -Djava.ext.dirs=$path/plugins:$path/lib com.ibm.ws.security.util.PasswordEncoder "$password1")
          if [[ $result != *ERROR* ]]; then
            echo $result | awk '{split($0,a,","); print a[2]}' | awk '{$1=$1};1'
          else
            echo "Something wrong, please check your password again!"
            echo $result | awk '{$4="";print}'
          fi
      fi
    else
       echo "One or more of the password is empty."
       echo "Plase check again!"
    fi
    ;;
  *)
    echo "To run it just execute $0"
 ;;
esac

echo $thank
echo
