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


Ideas/Todos/roadmap
-----------

### Main

- fix tail of log files in open iTerms, it runs to fast and causes probs

- Fix so this is set as required for any of the projects (`mobile`)

    export SITE_ID=1000

- turn into gem

- make so can start and app itself goes into background (demon) -> vagas

- add call, control and status off, `vm-control`

- server output log to file, not console

- make it work for non-foreman servers

- select project name and it cycle round the start/nothing/stop radios

- change start/nothing/stop radios to a traffic light pic

- on select of quick start link change link to loading gif until its loaded then display stop link

- on press of go button all start/stop links to change to loading gif until loaded

- add field to add/remove base path for projects (remove default path from app)

- then get projects from dir and not default_projects

- add field for port number (defaulted from forman, can override)

- get options to open log file in term/tab working

- add link to open the log file in tab

- allow error box to closed by user by clicking on X

- allow error box to timeout autoclose 5 sec

- icons (twitter bootstrap)

- start/stop radios to be set selected/active correctly depending on running project


## Contrib notes

## Contributors

* TimT -> JavaScript


## Licence
