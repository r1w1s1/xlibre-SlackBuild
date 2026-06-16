#!/bin/bash

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

for driver in \
  xf86-input-evdev \
  xf86-input-libinput \
  xf86-input-synaptics \
  xf86-input-vmmouse \
  xf86-input-wacom \
  xf86-video-amdgpu \
  xf86-video-ati \
  xf86-video-dummy \
  xf86-video-intel \
  xf86-video-mach64 \
  xf86-video-mga \
  xf86-video-neomagic \
  xf86-video-nouveau \
  xf86-video-openchrome \
  xf86-video-r128 \
  xf86-video-s3virge \
  xf86-video-savage \
  xf86-video-trident \
  xf86-video-vesa \
  ; do
  PKGNAM=$driver ./fetch-xf86-driver.sh
done
