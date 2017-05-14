<!--
    P2P-filter-lists is a script to download lists of IPs.
    Copyright (C) 2017  Rémi Ducceschi (remileduc) <remi.ducceschi@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
-->

[![License GPL v3.0](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg)](https://github.com/remileduc/p2p-filter-lists/blob/master/LICENSE)

p2p-filter-lists
================

Download several lists from https://www.iblocklist.com/lists and concatenate them into one .p2p file. Particularly useful for qBottirrent, but can be used for other softwares too.

The script downloads several lists and concatenate them into one `.p2p` file. This type of file can be directly loaded in several Bittorrent clients like qBittorent, Ktorrent or others... Currently, these lists are downloaded, but you can easily add or remove some by editing the script:

- level1
- level2
- level3
- ads
- badpeers
- bogon
- pedophile
- spyware

For Linux
=========

You can simply run the script. The final file will be created in `/tmp/qbittorrent_lists_$USER.p2p`.

For Windows
===========

You can run the script by simply double clicking on it. Nothing will happen until it is finished (1 or more minutes depending on your Internet connection), where a popup will show telling you the script is finished.

For Windows, you need the `bin` folder as it contains an executable for `wget`, to download the lists.

The created file will be located in `%TEMP%\qbittorrent\list.p2p`, so usually in `C:\Users\<username>\AppData\Local\Temp\qbittorrent\list.p2p`.

With qBittorrent
================

You can setup the path to the created link in *Tools -> Options... -> Connections*. At the bottom of the page, you have the section *IP filtering* where you can put the correct path, that depends on your OS (see above).

Every now and then (like every 2 days), you can run the script, and once it is finished, simply refresh the IP filtering in qBittorrent by clicking on the green arrow.
