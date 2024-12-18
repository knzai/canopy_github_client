The repository contains a basic Github client for its REST API.

## Requirements
* Ruby 3.1
* Access to at least one Github repository
* Please create a personal access token for your personal account so that the Github API requests work. The repository is public, so any token will work.

## Instructions
It needs to be run at the command line like this

```
TOKEN=github_pat_xxx ruby process.rb <repository URL, like https://api.github.com/repos/user_or_organization/repo>
```

or, if you use Bundler, remember to put your ENV variables *before* the command so Bundler doesn't try to parse them via
it's CLI parsing

```
TOKEN=github_pat_xxx bundle exec ruby process.rb <repository URL, like https://api.github.com/repos/user_or_organization/repo>
```

The code implements only one method in the API - `issues`. It outputs up to an a "per_page" parameter in the provided repository. It lets you set whether the issues returned are open or closed, and then displays them in decreasing order of date as follows:

1. If you selected open issues, the date used is the issue's created date.
2. Else, it's the issues' closed date.

Number 2 is possibly not correct, atm. It may right now be only sorting at updated_at which is close, but different

