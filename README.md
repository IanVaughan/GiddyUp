GiddyUp
=======

A web based view to select and control the running of our projects.

1. It gives you a list of available projects

1. you select which ones you want to start

1. hit start

1. it spins them up behind the scenes (using `foreman start` atm)

1. and opens up a new term tab for each tailing the log


To start it :-

    bin/giddyup server


Ideas/Todos
-----------

### Main

- fix tail of log files in open iTerms, it runs to fast and causes probs

- Fix so this is set as required for any of the projects (`mobile`)

    export SITE_ID=1000

- turn into gem

- make so can start and app itself goes into background (demon) -> vagas

- add call, control and status off, `vm-control`


### Views

- add field to add/remove base path for projects (remove default path from app)

- then get projects from dir and not default_projects

- List branches for each project in drop down

- add field for port number (defaulted from forman, can override)

- add option to open log file in term/tab

- maybe add link to open the log file in tabs


## Contrib notes

## Contributors

* TimT -> JavaScript


## Licence
