#!/bin/sh

# Copyright 2026  Patrick J. Volkerding, Sebeka, Minnesota, USA
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


PKGNAM=xlibre-xserver
REPOSITORY=https://github.com/X11Libre/xserver.git

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 PR-number" >&2
  exit 1
fi

PRNUM=$1
case "$PRNUM" in
  ''|*[!0-9]*)
    echo "$0: PR-number must be a positive integer" >&2
    exit 1
    ;;
esac
case "$PRNUM" in
  *[1-9]*)
    ;;
  *)
    echo "$0: PR-number must be a positive integer" >&2
    exit 1
    ;;
esac

for command in git find tar xz touch; do
  if ! command -v $command > /dev/null 2>&1; then
    echo "$0: required command not found: $command" >&2
    exit 1
  fi
done

WORKDIR=xserver-pr-${PRNUM}-$$
CLEANUP_PATH=$WORKDIR
ARCHIVE_BASE=
if [ -e "$WORKDIR" ]; then
  echo "$0: refusing to overwrite existing directory: $WORKDIR" >&2
  exit 1
fi

cleanup() {
  if [ -n "$CLEANUP_PATH" ]; then
    rm -rf "$CLEANUP_PATH" 2> /dev/null
  fi
  if [ -n "$ARCHIVE_BASE" ]; then
    rm -f "$ARCHIVE_BASE.tar" "$ARCHIVE_BASE.tar.xz" 2> /dev/null
  fi
}
trap cleanup 0 1 2 3 15

# Clone the repository, then fetch the exact head ref for the pull request.
git clone --no-checkout "$REPOSITORY" "$WORKDIR" || exit 1
( cd "$WORKDIR" &&
  git fetch origin "refs/pull/$PRNUM/head" || exit 1
  git checkout --detach FETCH_HEAD || exit 1
) || exit 1

HEADISAT="$( cd "$WORKDIR" && git log -1 --format=%h )"
DATE="$( cd "$WORKDIR" && git log -1 --format=%cd --date=format:%Y%m%d )"
LONGDATE="$( cd "$WORKDIR" && git log -1 --format=%cd --date=format:%c )"
if [ -z "$HEADISAT" ] || [ -z "$DATE" ] || [ -z "$LONGDATE" ]; then
  echo "$0: unable to read pull request HEAD metadata" >&2
  exit 1
fi

ARCHIVE=${PKGNAM}-${DATE}_${HEADISAT}
ARCHIVE_BASE=$ARCHIVE
if [ -e "$ARCHIVE" ] || [ -e "$ARCHIVE.tar" ] || [ -e "$ARCHIVE.tar.xz" ]; then
  echo "$0: refusing to overwrite existing source archive: $ARCHIVE" >&2
  exit 1
fi

# Cleanup.  We're not packing up the whole git repo.
( cd "$WORKDIR" && find . -type d -name ".git*" -prune -exec rm -rf {} \; 2> /dev/null )
mv "$WORKDIR" "$ARCHIVE" || exit 1
CLEANUP_PATH=$ARCHIVE
tar cf "$ARCHIVE.tar" "$ARCHIVE" || exit 1
xz -9 -f "$ARCHIVE.tar" || exit 1
touch -d "$LONGDATE" "$ARCHIVE.tar.xz" || exit 1
rm -rf "$ARCHIVE" || exit 1
CLEANUP_PATH=
ARCHIVE_BASE=

echo
echo "${PKGNAM} pull request #${PRNUM} with HEAD at ${HEADISAT} packaged as ${ARCHIVE}.tar.xz"
echo
