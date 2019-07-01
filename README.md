# RepoPusher

This is a command line script written in elixir to mass push git repositories to an organization. In the current version, you'd have to change the github urls in `CommandLine.CLI`. Future iterations of this project should allow you to put the org name as well as take advantage of OTP supervisors to ensure all repos are pushed (or at the very least report the failure).
****

## Installation
* clone and `cd` into this repository.
* `$ mix deps.get`
* `$ mix escripts.build`
* Now you can run the executable script by running: `$ ./repo_push <absolute_path_of_directory_containing_repos_to_be_pushed>`
