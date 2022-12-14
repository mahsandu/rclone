#!/usr/bin/env bash
# RClone Config file
RCLONE_CONFIG=/root/.config/rclone/rclone.conf
SCREEN_NAME=$(basename "$0" | cut -d '.' -f 1)
export RCLONE_CONFIG
export SCREEN_NAME

#exit if running
if ! [[ $(screen -S "$SCREEN_NAME" -Q select .) ]]; then
	echo "$SCREEN_NAME is running, exiting..."
     exit 1
fi

usage()
{
    echo "usage: rclone-sync-p0ds0smb.sh [-b | --bandwidth specify bandwidth as an integer | -h | --help shows this message]"
}

if [ "$1" != "" ]; then

BANDWIDTH=

while [ "$1" != "" ]; do
    case $1 in
        -b | --bandwidth )	shift
                                BANDWIDTH=$1
				export BANDWIDTH
                                ;;
        -h | --help )           usage
                                exit 0
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

screen -dmS $SCREEN_NAME bash -c 'rclone sync --bwlimit "$BANDWIDTH"M --progress --transfers 8 --checkers 10 --tpslimit 10 --update --filter-from $HOME/.config/rclone/filter-p0ds0smb.txt --drive-acknowledge-abuse --drive-use-trash=true --log-level INFO --delete-during --log-file $HOME/.config/rclone/log/upload-gcrypt-gavilan.log /mnt/pool0/p0ds0smb gcrypt-gavilan:/p0ds0smb 2>&1 | tee $HOME/.config/rclone/log/gcrypt-gavilan.log'
else
screen -dmS $SCREEN_NAME bash -c 'rclone sync --bwlimit 4M --progress --transfers 8 --checkers 10 --tpslimit 10 --update --filter-from $HOME/.config/rclone/filter-p0ds0smb.txt --drive-acknowledge-abuse --drive-use-trash=true --log-level INFO --delete-during --log-file $HOME/.config/rclone/log/upload-gcrypt-gavilan.log /mnt/pool0/p0ds0smb gcrypt-gavilan:/p0ds0smb 2>&1 | tee $HOME/.config/rclone/log/gcrypt-gavilan.log'
fi
