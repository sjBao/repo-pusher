# RepoPusher

This is a command line script written in elixir to concurrently mass push git repositories to an organization. In the current version, you'd have to change the github urls in `CommandLine.CLI`. Future iterations of this project should take advantage of OTP supervisors to ensure all failed pushes are restarted and or reported on.
****

## Installation
* clone and `cd` into this repository.
* `$ mix deps.get`
* `$ mix escript.build`
* Now you can run the executable script by running: `$ ./repo_push <arg1> <arg2>`
  * `arg1` is the *absolute path* containing the repos that you want to mass push
  * `arg2` is the org-name in the url

