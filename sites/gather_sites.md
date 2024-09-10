## actions.sh
```sh
#!/usr/bin/env bash

function sites_actions() {
  declare -A actions
  actions[\?]="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[e]="vim README.md"
  actions[C]="vim CHANGELOG.md"

  actions[F]="folder"
  actions[I]="images"
  actions[G]="git"

  actions[n]="create new site"
  actions[s]="restore site from github"

  echo
  hr
  P=" ${fgYellow}ARCHIVES${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      sites_actions
      ;;
    q) clear -x; ;;
    /) search; sites ;;

    n) sites_new; site ;;
    s) sites_restore; site ;;

    r) ranger_dir;  sites ;;
    t) tre; sites; ;;
    l) ll; sites_actions ;;

    e) v README.md; sites; ;;
    C) v CHANGELOG.md; sites; ;;

    '#')
      read -p "enter number: " number
      if [[ ${sites[$((number - 1))]} ]]; then
        dir="$(dirname ${sites[((number-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      site
      ;;
    [1-9]*)
      if [[ ${sites[$((action - 1))]} ]]; then
        dir="$(dirname ${sites[((action-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      site
      ;;
    0)
      last=$(( ${#sites[@]} - 1 ))
      cd $(dirname ${sites[ last ]})
      site
      ;;
    g)
      echo
      dir=$(sites_dirs | sed -e "s|$SITESROOT/\(.*\)/user/.photon|\1|" | fzf )
      cd "$SITESROOT/$dir/user"
      site
      ;;
    F) folder; ;;
    I) images; ;;
    G)
      clear -x
      ui_banner "git SITES"
      echo
      i=1
      for site in ${sites[@]}
      do
        dir=$(dirname "$site")
        cd $dir

        title=$(sed -n -e 's/title: \(.*\)/\1/p' "$dir/config/site.yaml")

        ui_banner  "$i $title"
        echo "   ${dir}"
        echo
        gss
        echo
        ((i++))
      done
      read -n1 -p "press any key to continue"
      sites
      ;;
    *)
      echo
      echo " '$action' ${fgRed}not a command${txReset}"
      sites_actions
      ;;
  esac
}

```

## list.sh
```sh
#!/usr/bin/env bash

function sites_dirs() {
  find $SITESROOT -maxdepth 3 -type f -wholename "*/user/.photon" | sort
}

function sites_list() {
  sites=( $( sites_dirs ))
  sites_count=${#sites[@]}

  i=1

  # ui_banner "sites ${SEP} ${#sites[@]}"
  echo

  for site in ${sites[@]}
  do
    dir=$(dirname "$site")

    tmp=$PWD
    cd $dir
    title=$(sed -n -e 's/title: \(.*\)/\1/p' "config/site.yaml")
    title+=" $SEP ${fgPurple}$(git_branch) $SEP ${fgRed}$(gsss)${txReset} "
    cd $tmp

    ui_list_item_number $i "$title"
    ui_list_item "${fgg08}${dir#$PWD/}${txReset}"
    ((i++))
  done
  echo
}


```

## restore.sh
```sh
#!/usr/bin/env bash

function sites_restore() {
  clear -x
  ui_header "photon ✴ SITES restore"

  ORGNAME="$1"
  if [[ -z $ORGNAME ]]; then
    echo
    read -p "specify ORGNAME: " ORGNAME
  fi

  PROJECT="$2"
  if [[ -z $PROJECT ]]; then
    echo
    read -p "specify PROJECT in $ORGNAME: " PROJECT
  fi

  repo_check "$ORGNAME" "$PROJECT"
  REPO="git@github.com:$ORGNAME/$PROJECT.git"

  # test for repo check error
  if [[ $? = 0 ]]
  then
    echo
    h1 "sandbox grav"
    echo
    cd $SITESROOT/grav
    bin/grav sandbox -s $SITESROOT/$PROJECT
    ln -sf $SITESROOT/grav/.htaccess $SITESROOT/$PROJECT/

    echo
    h1 "clone $REPO"
    echo
    cd $SITESROOT/$PROJECT
    rm -rf user
    git clone --recurse-submodules $REPO $SITESROOT/$PROJECT/user

    cd $SITESROOT/$PROJECT/user
    git submodule foreach "pwd; \
      git checkout master; \
      git status -sb; \
      echo"

    if [[ $ISLOCAL = true ]]
    then
      apache_new $PROJECT
    fi
      
    #TODO: prompt for username
    cd $SITESROOT/$PROJECT
    bin/plugin login new-user \
      -u phi \
      -e phi@phiarchitect.com \
      -P b \
      -N "phi ARCHITECT" \
      -t "admin"
    cd $SITESROOT/$PROJECT/user
    
  else
    echo ${fgRed}ERROR!!${txReset}
    echo "$REPO" not found
  fi
}

```

## _main.sh
```sh
#!/usr/bin/env bash

export SITESROOT=~/SITES
export ISLOCAL=true
if [[ "$HOSTNAME" =~ .*com$ ]]
then
  # export SITESROOT=~
  export ISLOCAL=false
fi

# default org for github operations
# GITHUBORG="photon-platform"

source ~/.photon/sites/list.sh
source ~/.photon/sites/actions.sh
source ~/.photon/sites/new.sh
source ~/.photon/sites/restore.sh
source ~/.photon/sites/apache.sh
source ~/.photon/sites/site/_main.sh

alias S=sites

function sites() {
  cd $SITESROOT
  
  clear -x

  ui_header "ARCHIVES $SEP $PWD"

  sites_list

  sites_actions

  tab_title
}

function repo_check() {
  ORGNAME="$1"
  if [[ -z $ORGNAME ]]; then
    echo
    read -p "specify ORGNAME: " ORGNAME
  fi

  PROJECT="$2"
  if [[ -z $PROJECT ]]; then
    echo
    read -p "specify PROJECT in $ORGNAME: " PROJECT
  fi

  REPO="git@github.com:$ORGNAME/$PROJECT.git"
  echo
  echo "✴ check remote repo"
  echo $REPO
  echo
  git ls-remote $REPO
}

```

## new.sh
```sh
#!/usr/bin/env bash

# sandbox a new site with grav
# copy additional files
# set up apache

CLONE=starter.photon-platform.net

function sites_new() {
  clear -x
  ui_header "SITES $SEP NEW $SEP $PWD"

  ORGNAME="$1"
  if [[ -z $ORGNAME ]]; then
    echo
    read -p "specify ORGNAME: " ORGNAME
  fi

  PROJECT="$2"
  if [[ -z $PROJECT ]]; then
    echo
    read -p "specify PROJECT in $ORGNAME: " PROJECT
  fi

  repo_check "$ORGNAME" "$PROJECT"
  REPO="git@github.com:$ORGNAME/$PROJECT.git"

  # test for repo check error
  if [[ $? = 0 ]]
  then
    sudo pwd
    TITLE="$(ask_value "specify site TITLE")"

    START_TIME="$(date -u +%s)"

    echo
    echo "✴ cloning grav"
    cd $SITESROOT/grav
    bin/grav sandbox -s $SITESROOT/$PROJECT
    ln -sf $SITESROOT/grav/.htaccess $SITESROOT/$PROJECT/

    echo
    echo "✴ clone starter user"
    cd $SITESROOT/$PROJECT
    rm -rf user
    git clone --recurse-submodules $SITESROOT/$CLONE/user/.git $SITESROOT/$PROJECT/user
    tools_git_submodules_update

    echo
    h1 "✴ set config files"
    cd $SITESROOT/$PROJECT/user
    echo "✴ rename server config folder"
    mv starter.photon-platform.net $PROJECT

    echo
    echo "✴ set config files"
    grep "theme:" config/system.yaml

    echo
    echo update site title
    sed -i "s/^\(\s*title:\s*\).*/\1$TITLE/" config/site.yaml
    grep "title:" config/site.yaml

    echo
    echo update admin title
    sed -i "s/^\(\s*logo_text:\s*\).*/\1$TITLE/" config/plugins/admin.yaml
    grep "title:" config/plugins/admin.yaml

    echo
    echo update .photon title
    sed -i -e "s/^\(\s*export PROJECT=\).*/\1$PROJECT/" \
           -e "s/ph.*net/$PROJECT/g" \
           .photon
    grep "title:" .photon

    apache_new $PROJECT
    
    git remote set-url origin "$REPO"

    git add .
    git commit -m "init"

    echo
    h1 "create admin account"
    cd $SITESROOT/$PROJECT
    bin/plugin login new-user \
      -u phi \
      -e phi@phiarchitect.com \
      -P b \
      -N "phi ARCHITECT" \
      -t "admin"

    echo
    h1 "✴ init tntsearch"
    bin/plugin tntsearch index
    cd $SITESROOT/$PROJECT/user

    END_TIME="$(date -u +%s)"
    ELAPSED="$(($END_TIME-$START_TIME))"
    TIME=$(convertsecstomin $ELAPSED)
    
    echo
    h1 "clone to ${fgYellow}$PROJECT${txReset} is complete."
    h2 "elapsed: ${txBold}$TIME${txReset} m:s"

  else
    echo ${fgRed}ERROR!!${txReset}
    echo "$REPO" not found
  fi
}

```

## apache.sh
```sh
#!/usr/bin/env bash

# creates new apache confguration
# log directories
# enable site
# restart

function apache_new() {
    
  if [ $1 ]
  then
    sudo pwd

    echo
    echo "✴ create conf file:"
    sudo sed -e "s/grav/$1/g" /etc/apache2/sites-available/grav.conf | \
        sudo tee /etc/apache2/sites-available/$1.conf

    cat /etc/apache2/sites-available/$1.conf

    mkdir ~/SITES/LOGS/$1

    echo
    echo "✴ enable site"
    sudo a2ensite $1

    echo
    echo "✴ add host"
    addhost $1

    echo
    echo "✴ restart apache"
    sudo apache2ctl restart
  else
    echo "specify project name: apache_new my-web"
  fi
}

```

## site/actions.sh
```sh
#!/usr/bin/env bash

# TODO convert aliases to actions
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias grav-log="cd ${PROJECT_DIR};bin/grav logviewer"

function site_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[e]="vim README.md"
  actions[C]="vim CHANGELOG.md"
  actions[.]="vim .photon"
  
  actions[o]="open in browser"

  actions[p]="articles"
  actions[u]="plugins"
  actions[m]="themes"
  actions[c]="config"

  actions[w]="scss --watch"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}ARCHIVE${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      site_actions
      ;;
    q) clear -x; ;;
    /) search; site; ;;

    r) ranger; site; ;;
    t) tre; site; ;;
    l) ll; echo; site_actions; ;;

    e) v README.md; site; ;;
    C) v CHANGELOG.md; site; ;;
    .) v .photon ; site; ;;

    g) zd; folder;;
    o)
      echo open
      select target in local localadmin server serveradmin
      do
        case $target in
          local)
            open $LOCAL
            ;;
          localadmin)
            open $LOCAL/admin
            ;;
          server)
            open $SERVER
            ;;
          serveradmin)
            open $SERVER/admin
            ;;
        esac
        break
      done
      site
      ;;

    p) cd pages; pages; ;;
    u) cd plugins; plugins; ;;
    m) cd themes; themes; ;;
    c) cd config; folder; site; ;;


    h) sites; ;;
    j)
      next=$( dirname "${siblings[$((siblings_index + 1))]}" )
      echo $next
      if [[ -d "$next" ]]
      then
        cd ${next}
      fi
      site
      ;;
    k)
      if [[ $siblings_index > 0 ]]; then
        prev=$( dirname "${siblings[$((siblings_index - 1))]}" )
        echo $prev
        if [[ -d "$prev" ]]
        then
          cd ${prev}
        fi
      fi
      site
      ;;
    
    f) vf; site;;
    v) vr; site;;
    V) tools_grav; site ;;
    F) folder; ;;
    I) images; ;;
    G) tools_git; site ;;
    w) 
      gnome-terminal --working-directory=$PWD -- bash -c "source ~/.bashrc; swatch; exec bash"
      site
      ;;
    *)
      echo
      echo " not a command"
      site_actions
      ;;
  esac
}

```

## site/sync.sh
```sh
#!/usr/bin/env bash

# convertsecstohours() {
 # ((h=${1}/3600))
 # ((m=(${1}%3600)/60))
 # ((s=${1}%60))
 # printf "%02d:%02d:%02d\n" $h $m $s
# }

# convertsecstomin() {
 # ((m=${1}/60))
 # ((s=${1}%60))
 # printf "%02d:%02d\n" $m $s
# }

function sync() {
  if [ $1 ]
  then
    case $1 in
      push)
        if [ $2 ]
        then
          case $2 in
            all)
              sync_push_all
              ;;
            user)
              sync_push_user
              ;;
            *)
              echo "Enter options: sync push all or sync push user"
              ls
              ;;
          esac
        else
          cd $PLUGINS_DIR
          git status -sb
        fi
        ;;
      pull)
        if [ $2 ]
        then
          case $2 in
            backup)
              sync_pull_backup
              ;;
            pages)
              sync_pull_pages
              ;;
            *)
              echo "Enter options: sync pull backup or sync pull pages"
              ls
              ;;
          esac
        else
          cd $PLUGINS_DIR
          git status -sb
        fi
        ;;
      *)
        echo "Enter options: sync push or sync pull"
        ls
        ;;
    esac
  else
    cd $PLUGINS_DIR
    git status -sb
  fi
}

function sync_push_all() {
  cd "$PROJECT_DIR/"
  bin/grav clear-cache

  SOURCE_DIR="$PROJECT_DIR/"
  DEST_DIR=illumiphi.com:${SERVER_DIR}/

  echo
  echo full sync to server
  echo "source: $SOURCE_DIR"
  echo "dest: $DEST_DIR"
  echo
  echo "login to continue - Ctrl-c to stop"
  echo

  START_TIME="$(date -u +%s)"
  # excludes are relative to source dir
  rsync \
    --archive \
    --update \
    --compress \
    --stats \
    --progress \
    --copy-links \
    --exclude "/cache/*" \
    --exclude "/backup/*" \
    --exclude "/images/*" \
    --exclude "/logs/*" \
    --exclude "/user/data/tntsearch/*" \
    --exclude "/user/.sass-cache/" \
    --exclude "/user/.git/" \
    --delete \
    $SOURCE_DIR \
    $DEST_DIR

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"
}

function sync_push_user() {
  SOURCE_DIR="$PROJECT_DIR/user/"
  DEST_DIR=illumiphi.com:${SERVER_DIR}/user/

  echo
  echo user sync to server
  echo "source: $SOURCE_DIR"
  echo "dest: $DEST_DIR"
  echo
  echo "press enter to continue - Ctrl-c to stop"
  echo

  START_TIME="$(date -u +%s)"
  rsync \
    --archive \
    --update \
    --compress \
    --stats \
    --progress \
    --copy-links \
    --exclude "data/tntsearch/*" \
    --exclude ".git/" \
    --exclude ".sass-cache/" \
    --exclude "*.com/" \
    --exclude "*.net/" \
    --delete \
    $SOURCE_DIR \
    $DEST_DIR

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"
}

function sync_pull_backup(){
  cd "$PROJECT_DIR/"
  bin/grav clear-cache

  SOURCE_DIR=illumiphi.com:${SERVER_DIR}/
  DEST_DIR="/home/phi/SITES/.backup/$PROJECT/"

  echo
  echo pull sync from server backup
  echo "source: $SOURCE_DIR"
  echo "dest: $DEST_DIR"
  echo
  echo "login to continue - Ctrl-c to stop"
  echo

  START_TIME="$(date -u +%s)"
  # excludes are relative to source dir
  rsync \
    --archive \
    --update \
    --compress \
    --stats \
    --progress \
    --delete \
    $SOURCE_DIR \
    $DEST_DIR

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"
}

function sync_pull_pages(){
  cd "$PROJECT_DIR/"
  bin/grav clear-cache

  SOURCE_DIR=illumiphi.com:${SERVER_DIR}/user/pages/
  DEST_DIR="$PROJECT_DIR/user/pages/"

  echo
  echo pull sync from server backup
  echo "source: $SOURCE_DIR"
  echo "dest: $DEST_DIR"
  echo
  echo "login to continue - Ctrl-c to stop"
  echo

  START_TIME="$(date -u +%s)"
  # excludes are relative to source dir
  rsync \
    --archive \
    --update \
    --compress \
    --stats \
    --progress \
    --delete \
    $SOURCE_DIR \
    $DEST_DIR

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"
}

# alias dry-sync="rsync -auzvhPL --stats --delete --dry-run user/ illumiphi.com:${SERVER_DIR}/user/"
#
# alias sync="rsync -auzvhPL \
#   --stats \
#   --delete \
#   --exclude $PROJECT_DIR/user/.git \
#   --exclude $PROJECT_DIR/user/data/tntsearch/* \
#   $PROJECT_DIR/user/ \
#   illumiphi.com:${SERVER_DIR}/user/"
#
# alias dry-full-sync="rsync -auzvhPL \
#   --stats \
#   --dry-run \
#   --exclude $PROJECT_DIR/backup/* \
#   --exclude $PROJECT_DIR/cache/* \
#   --exclude $PROJECT_DIR/images/* \
#   --exclude $PROJECT_DIR/logs/* \
#   --exclude $PROJECT_DIR/user/.git \
#   --exclude $PROJECT_DIR/user/data/tntsearch/* \
#   --delete \
#   $PROJECT_DIR \
#   illumiphi.com:${SERVER_DIR}/"
#
# alias full-sync="rsync -auzvhPL \
#   --stats \
#   --exclude $PROJECT_DIR/user/.git \
#   --exclude $PROJECT_DIR/backup/* \
#   --exclude $PROJECT_DIR/cache/* \
#   --exclude $PROJECT_DIR/images/* \
#   --exclude $PROJECT_DIR/logs/* \
#   --exclude $PROJECT_DIR/user/data/tntsearch/* \
#   --delete \
#   $PROJECT_DIR/ \
#   illumiphi.com:${SERVER_DIR}/"

```

## site/images.sh
```sh
#!/usr/bin/bash
source ~/.photon/.functions


imgexportdir="${PROJECT_DIR}/user/images/exports"

cd $imgexportdir

for img in *.jpg
do
  img_slug=$(slugify "$img")
  img_meta=${img_slug}.meta.yaml

  echo $img
  echo $img_slug
  echo $img_meta
  cp "$img" "../$img_slug"

  echo title: $(getExif Title) > ../$img_meta
  echo description: $(getExif Description) >> ../$img_meta
  echo subject: [$(getExif Subject)] >> ../$img_meta
  echo hierarchicalSubject: [$(getExif HierarchicalSubject)] >> ../$img_meta
  echo creator: $(getExif Creator) >> ../$img_meta
  echo publisher: $(getExif Publisher) >> ../$img_meta

  echo
done

echo "import complete"
read -p "Remove staged exports: [y|n]" ask
if [[ $ask == "y" ]]
then
  rm *.jpg
fi

```

## site/swatch.sh
```sh
#!/usr/bin/env bash

function swatch() {

  clear
  ui_header "$PROJECT * SWATCH "
  tab_title "$PROJECT * SWATCH "

  h1 $PWD
  h2 "start time: $( date )"
  echo

  sass --watch $(swatch_dirs)
}

function swatch_dirs() {

  find $PROJECT_DIR/user/plugins -maxdepth 2 -type d -wholename *photon*/scss \
    | sed 's|/scss||' \
    | sed 's|\(.*\)|\1/scss:\1/assets|' \
    | sed 's|\n||'

  find $PROJECT_DIR/user/themes -maxdepth 2 -type d -wholename *photon*/scss  \
    | sed 's|/scss||' \
    | sed 's|\(.*\)|\1/scss:\1/css|' \
    | sed 's|\n||'
}

```

## site/_main.sh
```sh
#!/usr/bin/bash

source ~/.photon/sites/site/actions.sh
source ~/.photon/sites/site/pages/_main.sh
source ~/.photon/sites/site/plugins/_main.sh
source ~/.photon/sites/site/themes/_main.sh
source ~/.photon/sites/site/siblings.sh
source ~/.photon/sites/site/sync.sh
source ~/.photon/sites/site/swatch.sh

function site() {
  @
  source .photon
  
  clear -x

  ui_header "ARCHIVE $SEP $PROJECT"

  show_dir

  h1 "$(sed -n "s/^\(\s*title:\s*\)\(.*\)/\2/p" config/site.yaml)"
  site_siblings
  h2 "$((siblings_index + 1)) ${fgg08}of${txReset} $siblings_count"
  echo
  fmt="  ${fgYellow}%c${txReset} $SEP ${txBold}%s${txReset} $SEP %d $SEP ${fgRed}%s${txReset}\n"
  
  tmp=$PWD
  
  cd $tmp/pages
  printf "$fmt" "p" "articles" $(find . -name "*.md" | wc -l ) "$(gsss)"
  cd $tmp/plugins
  printf "$fmt" "u" "plugins" $(find . -name "blueprints.yaml" | wc -l ) "$(gsss)"
  cd $tmp/themes
  printf "$fmt" "m" "themes" $(find . -name "blueprints.yaml" | wc -l ) "$(gsss)"
  cd $tmp/config
  printf "$fmt" "c" "config" $(find . -name "*.yaml" | wc -l ) "$(gsss)"

  cd $tmp

  echo
  site_actions

  tab_title
}

```

## site/siblings.sh
```sh
#!/usr/bin/env bash


function site_siblings() {

  # siblings=$(sites_dirs | sort)

  siblings=( $( sites_dirs ))
  siblings_count=${#siblings[@]}

  i=0
  for sib in ${siblings[@]}
  do
    if [[ $( dirname "$sib" ) == $(pwd) ]]
    then
      siblings_index=$((i))
    fi
    ((i++))
  done

}


```

## site/pages/sort.sh
```sh
#!/usr/bin/bash



function sort_in_siblings() {
  clear -x
  ui_header "move within siblings"

  fmt_child="${fgYellow}%3d)${txReset} %s${txReset}\n"
  siblings=($(find $(dirname "$(pwd)") \
    -maxdepth 1 -mindepth 1 -type d | sort))

  i=0
  index=0
  for sib in ${siblings[@]}; do
    current=""

    if [[ $sib == $(pwd) ]]; then
      index=$i
      # echo $sib
      current=$fgRed
    fi
    ((i++))

    mds=(${sib}/*.md)
    md=${mds[0]}
    if test -f $md; then
      # yaml=$(cat $md | sed -n '/---/,/---/p')
      # title=$(echo "$yaml" | yq e title - )
      echo $sib
      printf "$fmt_child" $i "$current$sib"
      # printf "$fmt_child2" "$current$sib"
    else
      printf "$fmt_child" $i "no page"
    fi
  done
  echo
  echo "" $((index + 1)) of ${#siblings[@]}

  ui_footer "[j] move down | [k] move up | [q] quit"
  read -n1  action
  case $action in
    j)
      # move down

      echo ${siblings[index]}
      fromDir=$(basename -- ${siblings[index]})
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"
      echo $num1 $name1
      echo "to"
      echo ${siblings[$((index + 1))]}
      toDir=$(basename -- ${siblings[$((index + 1))]})
      echo $toDir
      num2="${toDir%.*}"
      name2="${toDir#*.}"
      echo $num2 $name2
      mv "../$fromDir" "../$num2.$name1"
      mv "../$toDir" "../$num1.$name2"
      # clear
      pages
      ;;
    k)
      # "move up"
      echo ${siblings[index]}
      fromDir=$(basename -- ${siblings[index]})
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"
      echo $num1 $name1
      echo "to"
      echo ${siblings[$((index - 1))]}
      toDir=$(basename -- ${siblings[$((index - 1))]})
      echo $toDir
      num2="${toDir%.*}"
      name2="${toDir#*.}"
      echo $num2 $name2
      mv "../$fromDir" "../$num2.$name1"
      mv "../$toDir" "../$num1.$name2"
      # clear
      pages
      ;;
    [1-9]*)
      clear
      pages
      ;;
    *)
      clear
      pages
      ;;
  esac
}

```

## site/pages/actions.sh
```sh
#!/usr/bin/env bash

function pages_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions['@']="site"
  actions[e]="vim README.md"
  actions[b]="renumber child folders"
  actions[n]="add new child page"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}ARTICLES${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      pages_actions
      ;;
    q) clear -x; ;;
    @) site ;;
    /) search; pages; ;;
    
    r) ranger; pages; ;;
    t) tre; pages; ;;
    l) ll; echo; pages_actions; ;;

    e) v README.md; pages; ;;

    g) zd; page; ;;
    h) cd ..; site; ;;
    k) cd ../plugins; plugins; ;;
    j) cd ../themes; themes; ;;
    '#')
      read -p "enter number: " number
      if [[ ${children[$((number - 1))]} ]]; then
        dir="$(dirname ${children[((number-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      page
      ;;
    [1-9]*)
      if [[ ${children[$((action - 1))]} ]]; then
        dir="$(dirname ${children[((action-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      page
      ;;
    0)
      last=$(( ${#children[@]} - 1 ))
      cd $(dirname ${children[ last ]})
      page
      ;;
    a)
      vim "${children[@]}"
      ;;
    f) vf; pages; ;;
    v) vr; pages; ;;
    F) folder; ;;
    I) images; ;;
    T) taxonomy; page; ;;
    G) tools_git; pages ;;
    b)
      page_children_renumber
      clear
      pages
      ;;
    n) clear; pages_new; clear; page; ;;
    *)
      pages
      ;;
  esac
}

```

## site/pages/scaffolds.sh
```sh
#!/usr/bin/env bash

declare -A scaffolds

function scaffolds_list() {
  find $PROJECT_DIR -type f -wholename "**/scaffolds/*.md"
}

function scaffolds_select ()
{
  for scf in $(scaffolds_list)
  do
    key="$( basename $scf )"
    # echo $scf;
    # echo $key
    scaffolds[$key]=$scf;
  done;
  key=$( scaffolds_keys | sort | fzf );
  echo ${scaffolds[$key]}
}

function scaffolds_keys ()
{
  for key in ${!scaffolds[@]};
  do
    echo $key;
  done
}

function scaffold_vars() {
  sed -n -e 's/.*\${\(.*\)}.*/\1/p' $1
}

function scaffold_edit() {
  v $( scaffolds_select )
}

function scaffold_edit_all() {
  v $( scaffolds_list )
}

```

## site/pages/_main.sh
```sh
#!/usr/bin/env bash

source ~/.photon/sites/site/pages/new.sh
source ~/.photon/sites/site/pages/actions.sh
source ~/.photon/sites/site/pages/sort.sh
source ~/.photon/sites/site/pages/scaffolds.sh
source ~/.photon/sites/site/pages/taxonomy/_main.sh
source ~/.photon/sites/site/pages/page/_main.sh

function pages() {

  @
  source .photon
  cd pages

  clear -x

  ui_header "ARTICLES $SEP $PROJECT"

  show_dir


  page_children

  pages_actions

  tab_title
}

```

## site/pages/new.sh
```sh
#!/usr/bin/bash

TEMPLATE_DIR=~/.photon/templates/

function pages_new() {

  clear
  ui_header "photon ✴ PAGE new"
  show_dir
  h1 "Select a template: "

  scaffold=$( scaffolds_select )
  if [[ $scaffold ]]; then
    
    clear
    ui_header "photon ✴ PAGE new"
    show_dir
    ncal -3
    echo
    scaffold_name=`sed -n -e 's/% name: \(.*\)/\1/p' $scaffold`
    h1 "$scaffold_name"
    h2 "$scaffold"
    echo

    scaffold_folder=`sed -n -e 's/% folder: \(.*\)/\1/p' $scaffold`
    echo folder type: $scaffold_folder
    
    scaffold_vars=( $( scaffold_vars $scaffold ) )

    for v in ${scaffold_vars[@]}
    do
      eval "unset $v"
    done

    # defs=( `sed -n -e 's/% def: \(.*\)/"\1"/p' $scaffold` )
    mapfile -t defs < <(sed -n -e 's/% def: \(.*\)/\1/p' $scaffold)
    # sed -n -e 's/% def: \(.*\)/"\1"/p' $scaffold | mapfile defs 
    # for def in ${defs[@]}
    for (( i = 0; i < ${#defs[@]}; i++))
    do
      # echo ${defs[i]}
      eval export "${defs[i]}"
    done

    for v in ${scaffold_vars[@]}
    do
      value="$(ask_value "$v" "${!v}" )"
      eval "export $v='$value'"
      if [[ $v=="start_dt" ]]
      then
        export start_dt_long="$(date '+%A, %B %d, %Y @ %I:%M%p' --date "$start_dt")"
      fi
    done

    # get page folder name from title
    case $scaffold_folder in 
      date)
        folder="$(date +%Y-%m-%d --date "$post_date")-$(slugify "$title")"
        ;;
      event)
        folder="$(date +%Y-%m-%d --date "$start_dt")-$(slugify "$title")"
        ;;
      list)
        folder=$(slugify "$title")
        ;;
      *)
        folder="$(printf "%02d" $(( ${#children[@]} + 1 )) ).$(slugify "$title")"
        ;;
    esac

    folder="$(ask_value "folder:" "${folder}" )"
    mkdir "$folder"

    newfile="$folder/$(basename $scaffold)"
    # envsubst < $scaffold > $newfile
    cat $scaffold | sed  -e '/^[%]/d' | envsubst > $newfile


    for v in ${scaffold_vars[@]}
    do
        eval "unset $v"
    done

    cd "$folder"
  else
    clear
    page
  fi

}

```

## site/pages/page/actions.sh
```sh
#!/usr/bin/env bash

function page_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[m]="move page in ordered siblings"
  actions[x]="trash page"
  actions[o]="open in browser"
  actions[y]="toggle YAML"

  actions['@']="site"
  actions[e]="vim *.md"
  actions[b]="renumber child folders"
  actions[n]="add new child page"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}ARTICLE${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      page_actions
      ;;
    q) clear -x; ;;
    e) vim *.md; page; ;;
    @) site ;;
    /) search; page; ;;

    r) ranger; page; ;;
    t) tre; page; ;;
    l) ll;  page_actions; ;;

    m) page_siblings_move; ;;
    y)
      if [[ $PAGESYAML == true ]]
      then
        PAGESYAML=false
      else
        PAGESYAML=true
      fi
      echo "set PAGESYAML=$PAGESYAML"
      page
      ;;
    g) zd; page; ;;
    h) page_parent; ;;
    j) page_sibling_get $((siblings_index + 1)) ;;
    k) page_sibling_get $((siblings_index - 1)) ;;

    [1-9]*) page_child_get $((action - 1)) ;;
    0) page_child_get $(( ${#children[@]} - 1 )) ;;
    a) vim "${children[@]}" ; page ;;
    '#')
      read -p "enter number: " number
      page_child_get $((number - 1))
      ;;

    f) vf; page; ;;
    v) vr; page; ;;

    o) page_open; page_actions ;;
    x) page_trash; ;;
    I) images; ;;
    F) folder; ;;
    L) 
      gnome-terminal --working-directory=$PWD -- bash -c "source ~/.bashrc; tools_log; exec bash"
      page
      ;;
    L) tools_log; page; ;;
    T) taxonomy; page; ;;
    G) tools_git; page ;;
    b)
      clear
      page_children_renumber
      page
      ;;
    n)
      clear
      pages_new
      page
      ;;
    *)
      page
      ;;
  esac
}

function page_open() {
  # walk up path
  url=${PWD#*/pages/}
  path="$( echo "$url" | sed -e 's|[0-9]\{2\}\.||g' )"
  path="$LOCAL/$path"
  echo opening $path
  open "$path"
}


function page_trash() {
  echo
  hr
  ui_banner "TRASH $SEP $PWD"
  echo
  h1 "Trash Current Page: $PWD"
  echo

  if [[ "$( ask_truefalse "continue" )" == "true" ]]; then
    current=$PWD
    cd ..
    gio trash "$current"
    # TODO: clear cache
    if [[ "$PWD" == "$PROJECT_DIR/user/pages" ]]; then
      pages
    else
      page
    fi
  fi
}

function page_parent() {
  # if parent equals pages call pages
  cd ..
  if [[ "$PWD" == "$PROJECT_DIR/user/pages" ]]; then
    pages
  else
    page
  fi
}

```

## site/pages/page/children.sh
```sh
#!/usr/bin/env bash

function page_children_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "*.md" -type f | sort 
}

function page_children() {
  children=( $(page_children_dirs) )
  children_count=${#children[@]}

  ui_banner "children ${fgg08}•${txReset} $children_count"
  echo

  i=1

  for md in ${children[@]}
  do
    yaml="$(cat $md | sed -n -e '/^---$/,/^---$/{ /^---$/d; /^---$/d; p; }')"
    # yaml=$(cat $md | sed -n '/---/,/---/p')
    title=$( echo "$yaml" | sed -n -e 's/^title:\s*\(.*\)/\1/p' )
    subtitle=$( echo "$yaml" | sed -n -e 's/^subtitle:\s*\(.*\)/\1/p' )

    ui_list_item_number $i "$( remove_quotes "$title" )"
    if [[ $subtitle ]]
    then
      ui_list_item "$( remove_quotes "$subtitle" )"
    fi
    ui_list_item "${fgg08}${md#./}${txReset}"

    ((i++))
  done
  echo
}

function page_child_get() {
  id=$1
  dir=$(dirname ${children[$id]})
  if [[ -d "$dir" ]]
  then
    cd "$dir"
  fi
  clear
  page
}

function page_children_renumber() {
  ui_header "renumber children:"

  i=1
  dirs=()

  children=( $(page_children_dirs) )
  children_count=${#children[@]}

  for f in ${children[@]}; do
    dir=$(dirname "$f")
    dirs+=( $dir )

    dname=$(basename -- "$dir")
    name="${dname#*.}"
    num="${dname%%.*}"

    if [[ "$num" =~ ^[0-9]+$ ]]; then
      printf -v newnum "%02d" $i
      ui_list_item_number $i "$newnum $name"
      ui_list_item  "$dname"
    else
      echo "not a numbered folder"
    fi
    ((i++))
  done
  echo

  ask=$(ask_truefalse "y to accept")
  echo
  if [[ $ask == "true" ]]; then
    echo
    for (( i = $(( ${#children[@]}-1 )); i>= 0; i-- )); do
      f=${children[$i]}
      dir=$(dirname "$f")
      dname=$(basename -- "$dir")
      name="${dname#*.}"
      num="${dname%%.*}"
      if [[ "$num" =~ ^[0-9]+$ ]]; then
        printf -v newnum "%02d" $(( i + 1 ))
        newdname="$newnum.$name"
        ui_list_item_number $i "$newdname"
        ui_list_item  "$dname"
        if [[ "$dname" != "$newdname" ]]; then
          mv -n "$dname" "$newdname"
        fi
      else
        echo "not a numbered folder"
      fi
    done
    pause_any
    echo
  fi
}

```

## site/pages/page/_main.sh
```sh
#!/usr/bin/env bash

source ~/.photon/sites/site/pages/page/actions.sh
source ~/.photon/sites/site/pages/page/siblings.sh
source ~/.photon/sites/site/pages/page/children.sh

function join_by { local IFS="$1"; shift; echo "$*"; }
function remove_quotes() {
  temp="${1%\'}"
  temp="${temp%\"}"
  temp="${temp#\'}"
  temp="${temp#\"}"
  echo "$temp"
}

function page() {

  clear

  ui_header "ARTICLE $SEP $PROJECT"

  show_dir

  mds=(*.md)
  md=${mds[0]}

  if test -f $md;
  then

    md_type=${md%.*}

    h2 "$fgg12$md - $( date '+%F %H:%M'  -r ${md} )"

    page_siblings
    h2 "$fgg12$((siblings_index + 1)) of $siblings_count"
    echo

    markdown_yaml_get $md
    eval "$(yaml_parse page)"

    if [[ $PAGESYAML == true ]]
    then
      echo "$yaml"
    else
      h1 "$( remove_quotes "$page_title" )"
      h2 "$( remove_quotes "$page_subtitle" )"

      if [[ $page_data_event_startDate ]]
      then
        dt="$( remove_quotes "$page_data_event_startDate" )"
        h2 "$(date '+%A, %B %d, %Y, %I:%M %p'   -d "$dt")"
      fi

      page_cats="$(join_by , "${page_taxonomy_category[@]}" )"

      page_tags="$(join_by , "${page_taxonomy_tag[@]}" )"
      
      page_pho="$(join_by , "${page_taxonomy_photon[@]}" )"

    fi

    summary=$(tail -n +2 $md | sed -n -e '/^---$/,/^===$/{ /^---$/d; /^===$/d; p; }' | sed 's/^/ /')
    if [[ -n $summary ]]
    then
      width=$(tput cols)
      echo "$summary" | fold -w $((width-4)) -s
      echo
    fi

    if [[ $page_cats ]]; then
      h2 "  ${fgGreen}c:${txReset} ${page_cats}"
    fi
    if [[ $page_tags ]]; then
      h2 "  ${fgGreen}t:${txReset} ${page_tags}"
    fi
    if [[ $page_pho ]]; then
      h2 "  ${fgGreen}p:${txReset} ${page_pho}"
    fi
    echo

    # show headings from document indented
    grep -e "^#\{1,6\}" "$md"| sed -e "s/#/  /g"
    echo

    unset -v  $( ( set -o posix ; set ) | grep page_ | sed -n 's/\(.*\)\=(.*/\1/p' )

    page_children

    page_actions
  else
    h1 "page not found"
    echo
    la
  fi
  tab_title

}


```

## site/pages/page/siblings.sh
```sh
#!/usr/bin/env bash

function page_siblings() {
  siblings=( $(page_siblings_dirs) )
  siblings_count=${#siblings[@]}

  i=0
  for sib_md in ${siblings[@]}
  do
    if [[ $(dirname "$sib_md") == $(pwd) ]]
    then
      siblings_index=$i
    fi
    ((i++))
  done
}

function page_siblings_dirs() {
  parent_dir=$(dirname "$(pwd)")
  find $parent_dir -maxdepth 2 -mindepth 2 -name "*.md" -type f | sort
}

function page_sibling_get() {
  id=$1
  dir=$(dirname ${siblings[$id]})
  if [[ -d "$dir" ]]
  then
    cd "$dir"
  fi
  clear
  page
}

function page_siblings_move() {
  clear -x
  ui_header "Move page within siblings"

  h1 "$(dirname $(pwd))"
  echo

  i=0
  index=0

  siblings=( $(page_siblings_dirs) )
  siblings_count=${#siblings[@]}

  for sib_md in ${siblings[@]}
  do
    current=""

    if [[ $(dirname "$sib_md") == $(pwd) ]]
    then
      index=$i
      # echo $sib_md
      current=$fgRed
    fi
    ((i++))

    if test -f $sib_md;
    then
      # yaml=$(cat $sib_md | sed -n '/---/,/---/p')
      # title=$(echo "$yaml" | yq e "title" - )
      # printf "$fmt_child" $i "$current$si_mdb"
      # printf "$fmt_child2" "$sib_md"
      printf "$fmt_child" $i "$current$(basename $(dirname ${sib_md}))"
    else
      printf "$fmt_child" $i "no page"
    fi
  done
  echo
  echo "" $((index + 1)) of ${#siblings[@]}

  ui_footer "[j] move down | [k] move up | [q] quit"
  read -n1  action
  case $action in
    j)
      clear
      echo "move down"
      echo "swap: "

      fromDir=$(basename $(dirname ${siblings[index]}))
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"

      toDir=$(basename $(dirname ${siblings[$((index + 1))]}))
      echo $toDir
      num2="${toDir%.*}"
      name2="${toDir#*.}"

      mv "../$fromDir" "../$num2.$name1"
      mv "../$toDir" "../$num1.$name2"
      cd "../$num2.$name1"
      pwd
      # clear
      page_siblings_move
      ;;
    k)
      clear
      echo "move up"
      echo "swap: "

      fromDir=$(basename $(dirname ${siblings[index]}))
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"

      toDir=$(basename $(dirname ${siblings[$((index - 1))]}))
      echo $toDir
      num2="${toDir%.*}"
      name2="${toDir#*.}"

      mv "../$fromDir" "../$num2.$name1"
      mv "../$toDir" "../$num1.$name2"
      cd "../$num2.$name1"
      pwd
      # clear
      page_siblings_move
      ;;
    [1-9]*)
      clear
      page
      ;;
    *)
      clear
      page
      ;;
  esac
}

```

## site/pages/taxonomy/actions.sh
```sh
#!/usr/bin/env bash

function taxonomy_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}TAXONOMY${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      taxonomy_actions
      ;;
    q) clear; pages ;;
    c) taxonomy_list_categories; clear; taxonomy; ;;
    t) taxonomy_list_tags; clear; taxonomy; ;;
    p) taxonomy_list_photon; clear; taxonomy; ;;
  esac
}

function taxonomy_list_categories() {
  clear
  ui_banner "CATEGORY LIST: "
  
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_category[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    tax_value=(${tax_category[$tax_key]})
    tax_count=${#tax_value[@]}
    ui_list_item_number $(( i + 1 ))  "$tax_key ($tax_count)"
  done

  echo
  ui_banner "CATEGORY LIST actions: "

  read -s -n1  action
  case $action in

    '#')
      read -p "enter number: " number
      if [[ ${tax_keys[$((number - 1))]} ]]; then
        tax_key=${tax_keys[$((number - 1))]}
        vim -c "/$tax_key/" ${tax_category[$tax_key]}
      fi
      clear
      ;;
    [1-9]*)
      if [[ ${tax_keys[$((action - 1))]} ]]; then
        tax_key=${tax_keys[$((action - 1))]}
        vim -c "/$tax_key/" ${tax_category[$tax_key]}
      fi
      ;;
  esac
}

function taxonomy_list_tags() {
  clear
  ui_banner "TAG LIST: "
  
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_tag[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    tax_value=(${tax_tag[$tax_key]})
    tax_count=${#tax_value[@]}
    ui_list_item_number $(( i + 1 ))  "$tax_key ($tax_count)"
  done

  echo
  ui_banner "TAG LIST actions: "

  read -s -n1  action
  case $action in

    '#')
      read -p "enter number: " number
      if [[ ${tax_keys[$((number - 1))]} ]]; then
        tax_key=${tax_keys[$((number - 1))]}
        vim -c "/$tax_key/" ${tax_tag[$tax_key]}
      fi
      clear
      ;;
    [1-9]*)
      if [[ ${tax_keys[$((action - 1))]} ]]; then
        tax_key=${tax_keys[$((action - 1))]}
        vim -c "/$tax_key/" ${tax_tag[$tax_key]}
      fi
      ;;
  esac
}

function taxonomy_list_photon() {
  clear
  ui_banner "TAG LIST: "
  
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_photon[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    tax_value=(${tax_photon[$tax_key]})
    tax_count=${#tax_value[@]}
    ui_list_item_number $(( i + 1 ))  "$tax_key ($tax_count)"
  done

  echo
  ui_banner "TAG LIST actions: "

  read -s -n1  action
  case $action in

    '#')
      read -p "enter number: " number
      if [[ ${tax_keys[$((number - 1))]} ]]; then
        tax_key=${tax_keys[$((number - 1))]}
        vim -c "/$tax_key/" ${tax_photon[$tax_key]}
      fi
      clear
      ;;
    [1-9]*)
      if [[ ${tax_keys[$((action - 1))]} ]]; then
        tax_key=${tax_keys[$((action - 1))]}
        vim -c "/$tax_key/" ${tax_photon[$tax_key]}
      fi
      ;;
  esac
}

```

## site/pages/taxonomy/_main.sh
```sh
#!/usr/bin/env bash
source ~/.photon/sites/site/pages/taxonomy/actions.sh

function taxonomy() {

  clear -x

  ui_header "TAXONOMY $SEP $PROJECT"


  declare -A tax_category
  declare -A tax_tag
  declare -A tax_photon

  taxonomy_index
  clear
  ui_header "$PROJECT * TAXONOMY "
  show_dir
  echo

  fmt="  [%c] ${fgYellow}%3d${txReset} ${txBold}%s${txReset}\n"
  
  printf "$fmt" "c" ${#tax_category[@]} "categories"
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_category[@]}" | sort -z )
  join_by , "${tax_keys[@]}" 
  echo
  
  printf "$fmt" "t" ${#tax_tag[@]} "tags"
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_tag[@]}" | sort -z )
  join_by , "${tax_keys[@]}" 
  echo
  
  printf "$fmt" "p" ${#tax_photon[@]} "photon"
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_photon[@]}" | sort -z )
  join_by , "${tax_keys[@]}" 
  echo
  
  echo
  taxonomy_actions
}

function taxonomy_index() {
  
  mapfile -t pages_below < <(find . -type f -name "*.md" | sort)

  h1 "indexing pages..."

  for (( i = 0; i < ${#pages_below[@]}; i++ ))
  do
    md=${pages_below[i]}
    h1 "$md"

    markdown_yaml_get "$md"
    eval "$(yaml_parse page)"

    index_page_categories 
    index_page_tags
    index_page_photon

    unset -v  $( ( set -o posix ; set ) | grep page_ | sed -n 's/\(.*\)\=(.*/\1/p' )
  done
  
}

function index_page_categories() {
  for tax_key in  ${page_taxonomy_category[@]}
  do
    tax_category[$tax_key]+="$md "
  done
}

function index_page_tags() {
  for (( j = 0; j < ${#page_taxonomy_tag[@]}; j++ ))
  do
    tax_tag[${page_taxonomy_tag[j]}]+="$md "
  done
}

function index_page_photon() {
  for tax_key in  ${page_taxonomy_photon[@]}
  do
    tax_photon[$tax_key]+="$md "
  done
}

```

## site/plugins/actions.sh
```sh
#!/usr/bin/env bash

function plugins_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[n]="new plugin"
  actions[c]="create new submodule"
  actions[b]="restore plugin from github"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}PLUGINS${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      plugins_actions
      ;;
    q) clear -x; ;;
    @) site ;;
    /) search; plugins; ;;

    r) ranger_dir; folder; ;;
    t) tre; plugins; ;;
    l) ll; plugins_actions; ;;

    e) v README.md; plugins; ;;

    g) zd; folder ;;
    h) site; ;;
    j) cd ../pages; pages; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${list[((number-1))]})"
      cd $dir
      plugin
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      plugin
      ;;

    f) vf; plugins;;
    v) vr; pages; ;;

    F) folder; ;;
    I) images; ;;
    G)
      tools_git
      plugins
      ;;
    n)
      # new plugin from template
      pr
      bin/plugin photon newplugin
      ;;
    c) plugin_create_submodule ;;
    b) plugin_restore;  ;;
    remove) plugin_remove_submodule ;;
    *)
      plugins
      ;;
  esac

}

```

## site/plugins/list.sh
```sh
#!/usr/bin/env bash
function plugins_list_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort
}

function plugins_list() {

  list=( $(plugins_list_dirs) )
  list_count=${#list[@]}

  i=1

  ui_banner "plugins $SEP $list_count"
  echo

  for plugin in ${list[@]}
  do
    export yaml=$(cat $plugin)
    eval "$(yaml_parse plugin)" 2> /dev/null

    dir=$(dirname "$plugin")

    tmp=$PWD
    cd $dir
    stat=" $SEP ${fgPurple}$(git_branch) $SEP ${fgRed}$(gsss)${txReset} "
    cd $tmp
    ui_list_item_number $i "$(remove_quotes "$plugin_name") $SEP $plugin_version $stat"
    ((i++))
  done
  echo
}


```

## site/plugins/_main.sh
```sh
#!/usr/bin/env bash

source ~/.photon/sites/site/plugins/list.sh
source ~/.photon/sites/site/plugins/actions.sh
source ~/.photon/sites/site/plugins/plugin/_main.sh

function plugins() {
  @
  source .photon
  cd plugins
  clear -x 

  ui_header "PLUGINS $SEP $PROJECT"

  show_dir

  plugins_list

  plugins_actions
  tab_title

}

function plugin_restore() {
  ui_header "restore plugin submodule"

  if [[ $1 ]]; then
    name=$1
  else
    read -p "enter plugin name (without photon-): " name
  fi

  echo
  echo "*** add repo as submodule"
  git submodule add --force https://github.com/photon-platform/grav-plugin-photon-$name.git photon-$name

  echo
  echo "*** update submodules within submodule"
  git submodule update --init --recursive

  # echo
  # echo "*** push to repo"

  # git add .
  # git commit -m "add submodule plugin: photon-$name"
  # git push -fu origin master

  # git gc --aggressive --prune=all
}

```

## site/plugins/plugin/actions.sh
```sh
#!/usr/bin/env bash

function plugin_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}PLUGIN${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      plugin_actions
      ;;
    q) clear -x; ;;
    @) cd ..; site ;;
    /) search; plugin; ;;

    r) ranger_dir; folder; ;;
    t) tre; plugin; ;;
    l) ll; plugin_actions; ;;

    e) v README.md ; plugin; ;;
    c) v CHANGELOG.md; plugin; ;;
    .) v blueprints.yaml ; plugin; ;;

    g) zd; folder;;
    h) cd ..; plugins; ;;
    j)
      next=$(dirname ${siblings[$((siblings_index + 1))]})
      if [[ -d "$next" ]]
      then
        cd "$next"
      fi
      plugin
      ;;
    k)
      prev=$(dirname ${siblings[$((siblings_index - 1))]})
      if [[ -d "$prev" ]]
      then
        cd "$prev"
      fi
      plugin
      ;;
    f) vf; plugin; ;;
    R) report_plugin > README.md;
      mkdir -p docs;
      cp README.md docs/index.md;
      v README.md;
      plugin ;;
    I) images; ;;
    F) folder; ;;
    G)
      tools_git
      plugin
      ;;
    n)
      plugins_new
      plugin
      ;;
    *)
      plugin
      ;;
  esac
}

```

## site/plugins/plugin/_main.sh
```sh
#!/usr/bin/env bash

source ~/.photon/sites/site/plugins/plugin/actions.sh
source ~/.photon/sites/site/plugins/plugin/siblings.sh

function plugin() {
  clear -x

  ui_header "PLUGINS $SEP $PROJECT"

  show_dir
  plugin_siblings

  cat blueprints.yaml | head -n 12 | awk '{printf "  %s\n", $0}'
  # | xargs printf "    %s"
  echo

  plugin_actions
  tab_title
}

```

## site/plugins/plugin/siblings.sh
```sh
#!/usr/bin/env bash


function plugin_siblings_dirs() {
  parent_dir=$(dirname "$(pwd)") 
  find $parent_dir -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort 
}

function plugin_siblings() {

  siblings=( $(plugin_siblings_dirs) )
  siblings_count=${#siblings[@]}

  i=0
  for sib in ${siblings[@]}
  do
    if [[ $(dirname "$sib") == $(pwd) ]]
    then
      siblings_index=$i
    fi
    ((i++))
  done

}


```

## site/themes/actions.sh
```sh
#!/usr/bin/env bash

function themes_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}THEMES${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      themes_actions
      ;;
    q) clear -x; ;; # quit
    @) site ;;
    /) search; themes; ;;

    r) ranger_dir; folder; ;;
    t) tre; themes; ;;
    l) ll; themes_actions; ;;

    e) v README.md; pages; ;;

    g) zd; folder ;;
    h) site; ;;
    k) cd ../pages; pages; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${list[((number-1))]})"
      cd $dir
      theme
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      theme
      ;;
    f) vf; themes;;
    v) vr; pages; ;;
    F) folder; ;;
    I) images; ;;
    G)
      tools_git
      themes
      ;;
    *)
      themes
      ;;
  esac

}

```

## site/themes/list.sh
```sh
#!/usr/bin/env bash
function themes_list_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort 
}

function themes_list() {

  list=( $(themes_list_dirs) )
  list_count=${#list[@]}

  i=1

  ui_banner "themes $SEP $list_count"
  echo

  for theme in ${list[@]}
  do
    export yaml=$(cat $theme)
    eval "$(yaml_parse theme)" 2> /dev/null

    dir=$(dirname "$theme")

    tmp=$PWD
    cd $dir
    stat=" $SEP ${fgPurple}$(git_branch) $SEP ${fgRed}$(gsss)${txReset} "
    cd $tmp
    ui_list_item_number $i "$(remove_quotes "$theme_name") $SEP $theme_version $stat"
    ((i++))
  done
  echo
}


```

## site/themes/_main.sh
```sh
#!/usr/bin/env bash

source ~/.photon/sites/site/themes/list.sh
source ~/.photon/sites/site/themes/actions.sh
source ~/.photon/sites/site/themes/theme/_main.sh

function themes() {
  @
  source .photon
  cd themes
  clear -x

  ui_header "THEMES $SEP $PROJECT"

  show_dir

  themes_list

  themes_actions

  tab_title
}

```

## site/themes/theme/actions.sh
```sh
#!/usr/bin/env bash

function theme_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}THEME${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      theme_actions
      ;;
    q) clear -x; ;;
    @) cd ..; site ;;
    /) search; theme; ;;
    
    r) ranger_dir; folder; ;;
    t) tre; theme; ;;
    l) ll; echo; theme_actions; ;;

    e) v README.md ; theme; ;;
    c) v CHANGELOG.md; theme; ;;
    .) v blueprints.yaml ; theme; ;;

    g) zd; folder; ;;
    h) cd ..; themes; ;;
    j)
      next=$(dirname ${siblings[$((siblings_index + 1))]})
      if [[ -d "$next" ]]
      then
        cd "$next"
      fi
      theme
      ;;
    k)
      prev=$(dirname ${siblings[$((siblings_index - 1))]})
      if [[ -d "$prev" ]]
      then
        cd "$prev"
      fi
      theme
      ;;

    f) vf; theme; ;;
    v) vr; theme; ;;

    I) images; ;;
    F) folder;  ;;
    G) tools_git; theme; ;;
    R) report_theme > README.md; 
      mkdir -p docs;
      cp README.md docs/index.md;
      v README.md; 
      theme ;;
    n)
      themes_new
      theme
      ;;
    *)
      theme
      ;;
  esac
}

```

## site/themes/theme/_main.sh
```sh
#!/usr/bin/env bash

source ~/.photon/sites/site/themes/theme/actions.sh
source ~/.photon/sites/site/themes/theme/siblings.sh

function theme() {
  clear -x
  
  ui_header "THEME $SEP $PROJECT"

  show_dir
  theme_siblings

  cat blueprints.yaml | head -n 12
  echo

  theme_actions
  tab_title
}

```

## site/themes/theme/siblings.sh
```sh
#!/usr/bin/env bash


function theme_siblings_dirs() {
  parent_dir=$(dirname "$(pwd)") 
  find $parent_dir -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort 
}

function theme_siblings() {

  siblings=( $(theme_siblings_dirs) )
  siblings_count=${#siblings[@]}

  i=0
  for sib in ${siblings[@]}
  do
    if [[ $(dirname "$sib") == $(pwd) ]]
    then
      siblings_index=$i
    fi
    ((i++))
  done

}


```

