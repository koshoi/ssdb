# ssdb

Welcome to

```
  ______    ______   _______   _______
 /      \  /      \ /       \ /       \
/$$$$$$  |/$$$$$$  |$$$$$$$  |$$$$$$$  |
$$ \__$$/ $$ \__$$/ $$ |  $$ |$$ |__$$ |
$$      \ $$      \ $$ |  $$ |$$    $$<
 $$$$$$  | $$$$$$  |$$ |  $$ |$$$$$$$  |
/  \__$$ |/  \__$$ |$$ |__$$ |$$ |__$$ |
$$    $$/ $$    $$/ $$    $$/ $$    $$/
 $$$$$$/   $$$$$$/  $$$$$$$/  $$$$$$$/
```

SSDB stands for Supremely Stupid DataBase

The project started as a small training in bash scripting but ended up being very useful storage for local scripts

Key features are:
- single script distribution
- no DB server needed
- extremely simple
- snapshot can be edited in vim if needed
- clipboard integration
- values can be encrypted

## Installation

Basicaly you need to copy ssdb executable to somewhere in your $PATH

```bash
git clone https://github.com/okoshovetc/ssdb.git
cd ssdb
./runtest.sh
cp ssdb /usr/bin
```

## Usage

```bash
# set a key in ssdb
ssdb set key value

# list keys in database
ssdb list

# get a key from ssdb
ssdb get key

# copy a key to system clipboard
ssdb copy key

# store value from clipboard in ssdb
ssdb paste key2

# use another ssdb database
ssdb -D anotherdatabase list

# encrypt your values with openssl
ssdb -e mysecretkey set secretkey value

# read documentation
ssdb help

# read documentation for a specific command
ssdb help set
```

## Examples (some scripts I use daily)

### Browser bookmarks

```bash
#!/bin/bash

set -euo pipefail

export SSDB_DATABASE=links
link=$(ssdb get "$(ssdb list | sort | dmenu -l 30 -p 'Choose a bookmark')")

[ -z "$link" ] && exit 1

chromium-browser --new-window "$link"
```

### Clipboard manager

```bash
#!/bin/bash

set -euo pipefail

export SSDB_DATABASE=clipboard

mode="${1:-load}"

if [ "$mode" == 'load' ]; then
	clipname=$(ssdb ls | dmenu -l 30 -p 'Choose a link')
	if [ -z "$clipname" ]; then
		echo "Clipname empty"
		exit 1
	fi
	ssdb copy "$clipname"
	exit 0
fi

if [ "$mode" == 'save' ]; then
	clipname=$(printf '' | dmenu -l 30 -p 'Choose a link name' | sed 's/\s/_/g')
	ssdb paste "$clipname"
fi
```

### Password manager

```bash
#!/bin/bash

set -euo pipefail

xterm -e sh -c "ssdb -D password -r copy $(ssdb -D password list | dmenu -l 30 -p 'Choose a password to copy')"
```

### Zoom meetings launcher

```bash
#!/bin/bash

set -euo pipefail

export SSDB_DATABASE=zoom
url=$(ssdb list | sort | dmenu -l 30 -p 'Choose your zoom meeting')

killall zoom || true
sleep 0.1

zoom "--url=$(ssdb get "$url")"
```
