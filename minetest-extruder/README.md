# Minetest Extruder Tool (`extruder`)

This [Minetest](https://minetest.net) mod adds an extruder tool that can extend or reduce continuous surfaces towards the node face that was clicked.

* **Right click** ("place" action): extrude the clicked surface.
* **Left click** ("use" action): remove the clicked surface.
* **Right click on air** ("secondary use" action): open settings dialog.

## Settings

* **Extrusion amount**: How many nodes to extrude (or remove) on top of each node of the clicked surface.
* **Allow overwriting**: If enabled, existing nodes other than air in the space occupied by the extrusion will be overwritten.
* **Select through vertices (diagonally)**: If enabled, the selection will expand through vertices too. If disabled, it will expand only through sides. Here's an example. `░` is a node, `█` is the clicked node, `▓` is a selected node.
  * Disabled:
    ```
    ▓ ░░
    ▓█
    ```
  * Enabled:
    ```
    ▓ ▓▓
    ▓█
    ```
* **Only select nodes of the same type**: If enabled, the selection will expand only through the same node. For example, if you click on wood, only wood will be extruded. If disabled, the selection will expand through any node except air.

## How is it different from `//copy` from WorldEdit?

Good question!

WorldEdit operates on rectangular cuboids (boxes), so for example it isn't possible to extend the edge of a cylinder without also extending its contents.
`extruder` instead operates on surfaces of any shape and size.
It is also remarkably easier to use, not requiring any command at all.
On the other hand, at the moment `extruder` can only replicate a single 1-node-thin slice of the selection.

## License

Code is licensed under the EUPL-1.2-or-later.
You can find the text of this license in the LICENSE file or in multiple languages at https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12

Assets are licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
