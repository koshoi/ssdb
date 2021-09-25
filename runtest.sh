#!/bin/bash

set -euo pipefail

ssdb_ex="${1:-$PWD/ssdb}"

global_test_dir=$(mktemp -d -t 'ssdb.test.XXXXXXXXXX')
cp -r test "$global_test_dir"

tl=$(find "$global_test_dir/test" -maxdepth 1 -mindepth 1 -type d | sort | xargs echo)
read -ra testlist <<< "$tl"

for test_name in "${testlist[@]}"; do
	echo "Running $(basename "$test_name")"
	bash "$test_name/test" "$ssdb_ex"
done
