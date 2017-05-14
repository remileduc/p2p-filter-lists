#!/bin/bash

#    P2P-filter-lists is a script to download lists of IPs.
#    Copyright (C) 2017  Rémi Ducceschi (remileduc) <remi.ducceschi@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <http://www.gnu.org/licenses/>.

# Used to download IP filtered lists for qbittorent

set -eu -o pipefail

function main {
    # final created file
    outputFile="/tmp/qbittorrent_lists_$USER.p2p"
    # first, we create a tmp folder and we cd into it
    tmpdir="$(mktemp -dqp '/tmp' 'qbittorrent.XXXXXXXXXX')"
    cd "$tmpdir"

    echo "Downloading lists..."
    echo
    downloadLists
    echo "Extracting..."
    echo
    extractLists
    echo "Creating the list file..."
    echo
    concatenateLists "$outputFile"
    echo "Finalizing..."
    echo
    #rm -rf "$(pwd)"

    echo "Script finished! You can update the lists in qBittorrent via 'Tools -> Options... -> Connections'. At the bottom of the page, section 'Filtrage IP', click on 'reload' (green arrow)."
    echo
}

function downloadLists {
    lists=(
        # IP ranges of people who we have found to be sharing child pornography in the p2p community.
        "pedophile.7z http://list.iblocklist.com/?list=dufcxgnbjsdwmwctgfuj&fileformat=p2p&archiveformat=7z"
        # Companies or organizations who are clearly involved with trying to stop filesharing.
        # Companies which anti-p2p activity has been seen from.
        # Companies that produce or have a strong financial interest in copyrighted material.
        # Government ranges or companies that have a strong financial interest in doing work for governments.
        # Legal industry ranges.
        # IPs or ranges of ISPs from which anti-p2p activity has been observed.
        "level1.7z http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=7z"
        # General corporate ranges.
        # Ranges used by labs or researchers.
        # Proxies.
        "level2.7z http://list.iblocklist.com/?list=gyisgnzbhppbvsphucsw&fileformat=p2p&archiveformat=7z"
        # Many portal-type websites.
        # ISP ranges that may be dodgy for some reason.
        # Ranges that belong to an individual, but which have not been determined to be used by a particular company.
        # Ranges for things that are unusual in some way.
        # The level3 list is aka the paranoid list.
        "level3.7z http://list.iblocklist.com/?list=uwnukjqktoggdknzrhgh&fileformat=p2p&archiveformat=7z"
        # Unallocated address space.
        "bogon.7z http://list.iblocklist.com/?list=gihxqmhyunbxhbmgqrla&fileformat=p2p&archiveformat=7z"
        # Contains advertising trackers and a short list of bad/intrusive porn sites.
        "ads.7z http://list.iblocklist.com/?list=dgxtneitpuvgqqcpfulq&fileformat=p2p&archiveformat=7z"
        # Known malicious spyware and adware IP Address ranges.
        "spyware.7z http://list.iblocklist.com/?list=llvtlsjyoyiczbkjsxpf&fileformat=p2p&archiveformat=7z"
        # List of people who have been reported for bad deeds in p2p.
        "badpeers.7z http://list.iblocklist.com/?list=cwworuawihqvocglcoss&fileformat=p2p&archiveformat=7z"
    )
    echo "${lists[*]}" | xargs -n 2 -P 4 wget -O
}

function extractLists {
    ls *.7z | xargs -n 1 -P 8 7z x -aoa -y
}

# This function takes the outfile as first parameter
function concatenateLists {
    cat *.txt > "$1"
}

# we run the main
main
