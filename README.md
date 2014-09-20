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

To make this kanban generator suitable for student rather than software developer use, I've switched some of the organisation around. I've added a secondary folder for [blog and essay] writing ideas, with modified lane titles to reflect this. Intended more as an ideas board than for monitoring, WIP/done subcolumns have been removed and draft post IDs are used as attributes to generate links to continue work or to reference source articles if a first draft hasn't begun.

Regarding attributes:

	doi#<doi> - this generates a url to access the associated scholarly item
				at http://dx.doi.org/<doi>

	draft#<id> - this generates a url to access a blog draft (extensible
				 for whatever purpose/site seen fit)
				 Needs a little fiddling to strip out before first / to generate
				 the post edit URL

	url#<url> - simply associates a full link to item (should attach to title?)

	laverna#<laverna id> - self-hosted Laverna server instance (or on local HTML5 storage
			       at laverna.cc) notes accessible by an ID sim. Evernote.

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

### Work in progress

* Manipulation of the kanban/focussing it without repeatedly creating new tabs to check it using [Chromix](http://chromix.smblott.org/) - see below.
* Use of HTML5 drag and drop events to reorder items within a column, and more importantly to progress items. The alternative to this (i.e. if it's not possible to parse HTML page changes back into Markdown and send this via Chromix into a Javascript-manipulatable webapp in another tab like [flytext.in](http://flytext.in) - proof of concept for doing this is [here](https://gist.github.com/lmmx/c414a1d4822a025380e7)) is to just write some custom shell function that greps task titles, works out the subsection and edits the file accordingly (draft script for this is [here](https://gist.github.com/lmmx/8a6794a98286d00d6797)) - but this is messier, requiring assumption of the ordering of tasks in the kanban/markdown, and less intuitive than drag and drop.

### Useful .bashrc aliases with stupid names

Replacing {/gits/kanban} with the path to your local 'kanban' folder from this repo:

	alias yeswekanban='kanout="$(cd {/gits/kanban}; ./bin/kanban ./data.txt; cd - > /dev/null)"; echo $(echo $(echo "$kanout" | sed "1d;\$d" | sed "s/board .*$/board\.\.\./g")); echo $(echo "$kanout" | tail -1)'

Updates the HTML output - it's necessary to `cd` into the folder in this way, as a `html/` folder is created relative to the path it was executed from. `xdg-open` is equivalent to `open` on OS X. The `sed` and `tail` commands manipulate the output onto just two lines, hiding the board name.

	alias kankan='vim {/gits/kanban}/data.txt && yeswekanban'

Other text editors are available...

	alias seekanban='(xdg-open {/gits/kanban}/html/index.html &) > /dev/null 2>&1'

Chrome opens new tabs quite verbosely, so the command here is in a subshell and STDOUT/STDERR muted. `xdg-open` = `open` on OS X.

Taking this a bit further, [on Linux Mint] it's possible to have more elaborate constructions and `source` the .bashrc within custom keyboard shortcut commands. In my case, Ctrl-Alt-K ran

	google-chrome /home/louis/Dropbox/kanban/main/html/index.html

until I realised this would open multiple tabs each time I wanted to check the kanban - instead I installed [chromix](http://chromix.smblott.org/) which uses Node.js and a Chrome extension to exert finer control over a browser session. The following functions are loaded in each browser session - it's a first draft and it currently requires 2 calls to `gogochromix` to ensure definite response (but this is preferable over anything that repeatedly calls `chromix-server`, which can cause it to stop responding to ping requests).

	function pingpong { pingcheck=$(chromix ping; echo $?); }
	function quietly () { "$@" > /dev/null 2>&1; }
	function servertogo () {
		if [[ "$@" == '' ]]
		then
			echo "chromix-server is running"
		else
			chromix "$@"
		fi
	}
	function gogochromix () {
		quietly pingpong
		if [ $pingcheck == 0 ]
		then
			# Success, execute final chromix commands
			servertogo "$@"
		else
			quietly chromix-server & killid=$!
			sleep 1
			quietly pingpong
			if [ $pingcheck == 0 ]
			then
				# Success on second attempt, exit chromix commands
				servertogo "$@"
			else
				sleep 1
				if [ $pingcheck == 0 ]
				then
					servertogo "$@"
				else
					sleep 1
					if [ $pingcheck == 0 ]
					then
						servertogo "$@"
					else
						echo "giving up"
					fi
				fi
			fi
		fi
	}

For local files, the `load` command [will make chromix reload a page](http://chromix.smblott.org/#_load) (unlike for web pages), so it's necessary to check if the page can be focussed, and then load it. For all my uses so far the `load` command is fine - reloading a local file makes no difference and makes the page reflect changes to the markdown which I want. This is the difference between:

	gogochromix with file:///home/louis/Dropbox/kanban/main/html/index.html focus
	gogochromix load file:///home/louis/Dropbox/kanban/main/html/index.html

If the tab is open, the former returns a message beginning with "done"; if there's no such tab there is no output.

Chromix can send Javascript to be executed on the tab showing the kanban file with

	gogochromix with file:///home/louis/Dropbox/kanban/main/html/index.html goto javascript:(function(){ javascriptGoesHere; }())

In short, this could pick up any changes to the page and send them either back to the shell to update a local file or to a webapp connected to cloud storage and amenable to Javascript manipulation, such as [Flytext](http://flytext.in)

	gogochromix with https://flytext.in/ goto "javascript:(function(){ openFile('kanban/main/data.txt'); extendedJavascriptFunctionGoesHere; }())"

TBC
