GiddUp
======

A web based view to select and control the running of our projects.

1. It gives you a list of available projects

1. you select which ones you want to start

1. hit start

1. it spins them up behind the scenes (using `foreman start`)

1. and opens up a new term tab for each tailing the log


To start it :-

    bin/giddyup


Ideas/Todos
-----------

### Main

- fix tail of log files in open iterms, it runs to fast

- Fix so this is set as required for one of the projects (`mobile`)

    export WLD_SITE_ID=1000

- should this be used?

    Process.detach(pid)

- turn into gem

- make so can start and app itself goes into background (demon)

- add call, control and status off, vm-control


### Views

- add tick/untick

- add field to add/remove base path for projects (remove default path from app)

- then get projects from dir and not default_projects

- List branches for each project in drop down

- add field for port number (defaulted from forman, can override)

- add option to open log file in term/tab

- maybe add link to open the log file in tabs


licence

contrib notes

contributors
Tim js


todo
git up

