# Kanban

This directory contains the data and the tool to create an electronic version
of a Kanban card wall. The data is in the file data.txt, the tool is
the file kanban, the output goes to the html directory.

The input file "data.txt" contains a definition of the board, which
columns are on it, and which limits they have, as well as all the items, which
are on the board. It uses a simple markdown like text format, where the
columns are represented as sections, and each item by its own line.

The format of an item is:

    * <name of item> (<attributes>)

where <name of item> is the display name of the item, and <attributes> is a
comma-separated list of attributes.

## Louis's student kanban

To make this kanban generator suitable for student rather than software developer use, I've switched some of the organisation around.

Regarding attributes:

	bnc#<bugzilla id> - this attribute is no longer used (software bug ID number)

	doi#<doi> - this generates a url to access the associated scholarly item
				at http://dx.doi.org/<doi>

	draft#<id> - this generates a url to access a blog draft (extensible
				 for whatever purpose/site seen fit)
				 Needs a little fiddling to strip out before first / to generate
				 the post edit URL

	url#<url> - simply associates a full link to item (should attach to title?)

	@<task type> - no longer refers to a user, rather to the type of task
	               e.g. which course module it's for or if it's relating
	                    to extramural projects etc.
	               There can be more than one task type associated with an item.

    #<tag> - An arbitrary tag for the item. Tags also define classes of service,
             which are put into their respective swim lanes. Valid values for
             classes of service are ~~#emergency, #bug, #feature, and #maintenance~~.
			   (( will be edited, TBC ))

    in:<date> - The date the item was put into the "In" column in ISO format.

    due:<date> - The date the item has to be in the "Done" column. in ISO
                 format. Most items don't have a due entry.

    done:<date> - The date the item was put into the "Done" column in ISO format.

    trashed:<date> - The date the item was removed from the board in ISO format
                     for other reasons than being done.

From the original documentation (susestudio/kanban on GitHub):
	
\_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/

Items are listed in the column, which is represented by the section in which
they are in the input file. To move an item from one column to another its line
is simply moved to another section in the input file.

To create the output file as HTML file showing the card wall, run the kanban
tool with the input file as argument. It will write to the html directory:

    ./bin/kanban data.txt

Limits are automatically calculated and shown on the wall, violations are
indicated by red text.

Here is an example of how a generated board looks like:

![Screenshot example board](https://raw.github.com/lmmx/kanban/master/screenshot-board.png)

\_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/   \_/

With the modifications for student use, a lot of complexity can be taken out to give the basics of getting a task done - development/research/review, 'underway' and 'finalising':

![Screenshot example modified board](https://raw.github.com/lmmx/kanban/master/screenshot-student-board.png)

## Useful .bashrc aliases with stupid names

Replacing {/gits/kanban} with the path to your local 'kanban' folder from this repo:

	alias yeswekanban='kanout="$(cd {/gits/kanban}; ./bin/kanban ./data.txt; cd - > /dev/null)"; echo $(echo $(echo "$kanout" | sed "1d;\$d" | sed "s/board .*$/board\.\.\./g")); echo $(echo "$kanout" | tail -1)'

Updates the HTML output - it's necessary to `cd` into the folder in this way, as a `html/` folder is created relative to the path it was executed from. `xdg-open` is equivalent to `open` on OS X. The `sed` and `tail` commands manipulate the output onto just two lines, hiding the board name.

	alias kankan='vim {/gits/kanban}/data.txt && yeswekanban'

Other text editors are available...

	alias seekanban='(xdg-open {/gits/kanban}/html/index.html &) > /dev/null 2>&1'

Chrome opens new tabs quite verbosely, so the command here is in a subshell and STDOUT/STDERR muted. `xdg-open` = `open` on OS X.
