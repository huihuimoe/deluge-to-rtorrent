#!/bin/bash

if [[ -z "${SKIP_SLEEP+x}" ]]; then
  sleep 900
fi

torrentid=$1
torrentname=$2
torrentpath=$3

tmpdir=$(/usr/bin/mktemp -d)

##############################################################
# Define these vars to the path where they are located
##############################################################
dc=/usr/bin/deluge-console
deluge_state_dir=/home/rtorrent/.config/deluge/state
rtfr=/home/rtorrent/rtorrent_fast_resume.pl
download_dir=/home/downloads
xmlrpc=/usr/bin/xmlrpc
xmlrpc_endpoint=https://example.com/RPC2-abcdefg
xmlrpc_command="${xmlrpc} ${xmlrpc_endpoint}"
##############################################################


function on_exit() {
    rm -rf "${tmpdir}"
}

#trap on_exit EXIT

function set_tracker {
  case $1 in
    *alpharatio*)
   	  tracker=ar
      ;;
    *empire*|*stackoverflow*|*iptorrent*)
   	  tracker=ipt
      ;;
    *torrentleech*)
   	  tracker=tl
      ;;
   	*)
   	  tracker=$1
	  ;;
  esac
}

tracker_line=$($dc info $torrentid | grep "^Tracker" | awk -F: '{print $2}' | tr -d " ")
set_tracker $tracker_line
ratio=$($dc info $torrentid | grep Ratio: | awk -F "Ratio: " '{print $2}')

#echo $tracker
#echo $ratio
#echo $ratio_rounded_down

cp ${deluge_state_dir}/${torrentid}.torrent ${tmpdir}

$rtfr $download_dir ${deluge_state_dir}/${torrentid}.torrent ${tmpdir}/${torrentid}_fast.torrent
if [[ $? -ne 0 ]]; then
  echo "Something went wrong when converting the torrent file with $(basename ${rtfr})"
  echo "exiting..."
  exit 10
fi

# pause and remove the torrent from deluge
$dc pause $torrentid
$dc rm $torrentid
sleep 3

$xmlrpc_command load.start "" ${tmpdir}/${torrentid}_fast.torrent
sleep 3
$xmlrpc_command d.custom1.set "" ${torrentid} ${tracker}
$xmlrpc_command d.custom.set "" ${torrentid} deluge_ratio ${ratio}

/usr/bin/rm -rf $tmpdir
