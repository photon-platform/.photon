#!/usr/bin/env bash
capture_project=$USER

function tools_capture_actions() {

  echo
  hr
  P=" ${fgYellow}CAPTURE${txReset}"
  read -n1 -p "$P > " action
  echo
  echo
  # printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      tools_capture_actions
      ;;
    q) clear -x; ;; # quit
    l) gphoto2 --list-files; tools_capture_actions; ;;
    g) tools_capture_get_all_files; tools_capture_actions; ;;
    d) tools_capture_delete_all_files; tools_capture_actions; ;;
    *) tools_capture; ;;
  esac

}

function tools_capture_get_all_files() {
  capture_project=$( ask_value "project" "$capture_project" )
  capture_project=$( slugify "$capture_project" )

  capture_subject=$( ask_value "subject" "$capture_subject" )
  capture_subject=$( slugify "$capture_subject" )
  
  gphoto2 --get-all-files --filename "${HOME}/Media/${capture_project}/%Y/%m/%d/%H%M%S-${capture_subject}-%03n.jpg" 
}

function tools_capture_delete_all_files() {
  h1 "${fgRed}Delete all files on camera${txReset}"
  if [[ $( ask_truefalse "continue" ) == "true" ]]; then
    gphoto2 --recurse --delete-all-files
  fi 
}
