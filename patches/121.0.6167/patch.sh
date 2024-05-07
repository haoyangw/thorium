#!/bin/bash

CHROMIUM_SRC="${HOME}/chromium/src"

PATCH_DIR=$(dirname `readlink -f "$0"`)
echo "${PATCH_DIR}"
for patch in *.patch; do
	FILE=$(readlink -f "${patch}")
	cd "${CHROMIUM_SRC}"
	echo "Applying ${patch}"
	git apply "${FILE}"
	cd "${PATCH_DIR}"
done

cd "${PATCH_DIR}"
echo "Done"
exit 0
