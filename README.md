# deluge-to-rtorrent
Custom scripts I use to move torrents from deluge to rtorrent

Fork from [wseedbox/deluge-to-rtorrent](https://github.com/wseedbox/deluge-to-rtorrent)

Update command to make [rtorrent 0.9 compatible](https://github.com/rakshasa/rtorrent/blob/master/doc/scripts/update_commands_0.9.sed).

## Files

* deluge_to_rtorrent.sh: This is the script that is run from the execute plugin in deluge
* rtorrent_fast_resume.pl: This is a script that i copied from the rtorrent github page: https://github.com/rakshasa/rtorrent/blob/master/doc/rtorrent_fast_resume.pl

## Requirements

for Debian
```bash
sudo apt update
sudo apt install dh-make-perl xmlrpc-c deluge-console
mkdir perl && cd perl
dh-make-perl -build -cpan Convert::Bencode_XS
sudo dpkg -i *.deb
cd .. && rm -rf perl
```

### Programs
* deluge-console: This is required to read info and do operations from deluge.
* xmlrpc: This is used to make calls to rtorrent

## Setup

1. Copy these files to a bin dir.  I used ~/bin
2. Edit deluge_to_rtorrent.sh and make sure the path's match up.
3. In deluge, enable the "Execute" plugin.
4. Create a "Torrent Complete" Event.  Put in the whole path to deluge_to_rtorrent.sh

Notes:

* I've heard that you need to restart deluge after enabling the "Execute" plugin
* There is a sleep 900 at the top of the file.  This means it will take 15 minutes after the file has been completed to be moved.
* This can be used with the rutorrent plugin to show the values
* I like having labels in rtorrent.  There is a case statement that tries to add labels based on tracker.  This could probably be changed.

If you like the script, let me know.  It works for me, and I thought I'd share.
