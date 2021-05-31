# ehough/docker-kodi - Dockerized Kodi with audio and video.
#
# https://github.com/ehough/docker-kodi
# https://hub.docker.com/r/erichough/kodi/
#
# Copyright 2018-2020 - Eric Hough (eric@tubepress.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM alpine:3.14



# # install the team-xbmc ppa
# RUN apt-get update                                                        && \
#     apt-get -y purge openssl                                              && \
#     apt-get -y --purge autoremove                                         && \
#     apt-get dist-upgrade                                                  && \
# # Bugfix for: installed kodi package post-installation script subprocess returned error exit status 1
# # either install udev or make the required directory 
#     sudo apt-get install uuid-dev                                         && \
# #    mkdir -p /etc/udev/rules.d
#     rm -rf /var/lib/apt/lists/*                                           

# besides kodi, we will install a few extra packages:
#  - ca-certificates              allows Kodi to properly establish HTTPS connections
#  - kodi-eventclients-kodi-send  allows us to shut down Kodi gracefully upon container termination
#  - kodi-game-libretro           allows Kodi to utilize Libretro cores as game add-ons
#  - kodi-game-libretro-*         Libretro cores
#  - kodi-inputstream-*           input stream add-ons
#  - kodi-peripheral-*            enables the use of gamepads, joysticks, game controllers, etc.
#  - kodi-pvr-*                   PVR add-ons
#  - kodi-screensaver-*           additional screensavers
#  - lirc,lirc-compat-remotes     enables the use of IR Remotes
#  - locales                      additional spoken language support (via x11docker --lang option)
#  - pulseaudio                   in case the user prefers PulseAudio instead of ALSA
#  - tzdata                       necessary for timezone selection
RUN packages="                                               \
    bash                                                     \
    ca-certificates                                          \
    kodi                                                     \
    lirc                                                     \
    pulseaudio                                               \
    py3-pycryptodomex                                        \
    tzdata"                                               && \
                                                             \
    apk add --update-cache $packages                         \
    && rm -fr /var/cache/apk/*                      

RUN adduser --disabled-password -u 9002 kodi && addgroup kodi video

ADD /asound.conf /etc/asound.conf

# setup entry point
COPY entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
