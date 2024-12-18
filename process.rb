require 'octokit'

module Github
  class Processor
    # This class is responsible for processing the response from the Github API.
    # It accepts a client object and stores it as an instance variable.
    # It has a method called `issues` that returns a list of issues from the Github API.
    def initialize()
      @client = Octokit::Client.new(access_token: ENV['TOKEN'])
      
      # this is sort of a cheat, but if it works.... I feel like it's better to use the official client and it's approach
      # rather than reimplementing some handrolled version that needs to be maintained
      @client.auto_paginate = true
    end

    def issues(open: true, per_page: 500, newest_first: true)
      # This method returns a list of issues from the Github API.
      # It accepts an optional argument called `open` that defaults to true.
      # If `open` is true, it returns only open issues.
      # If `open` is false, it returns only closed issues.
      # It makes a GET request to the Github API using the official Octokit::Client.
      # It returns the response from the Github API.

      # per_page controls how many are returned. I'll need to play around with the `link` and `next` headers for calling
      # next page when they set exceeds one, but I wanted to get the basics working first
      # newest_first determines which direction the sort is in

      state = open ? 'open' : 'closed'
      sort_dir = newest_first ? 'desc' : 'asc'
      sort = open ? 'created' : 'updated'

      opts = {}
      opts[:direction] = newest_first ? 'desc' : 'asc'
      opts[:per_page] = per_page
      if open
        opts[:state] = 'open'
        date_col = 'created_at'
        date_text = "Created"
      else
        opts[:state] = 'closed'
        date_col = 'created_at'
        date_text = "Closed"
      end

      # I could keep the old algo of manually sorting responses on a paginated API if this is a hard requirement, but it's
      # very suboptimal to manually re-sort an API response that has a sort parameter, and "updated_at" is probably
      # a close or maybe even perfect proxy for closed at, so the sort should be about right anyway

      # Return a list of issues from the response, with each line showing the issue's title, whether it is open or closed.
      # The issues are sorted by the date they were updated ('closed') or created ('open'), with order depending on the newest_first param.

      issues = @client.list_issues 'paper-trail-gem/paper_trail', opts
      
      issues.each do |issue|
        puts "#{issue['title']} - #{issue['state']} - #{date_text} at: #{issue[date_col]}"
      end

    end
  end
end
# Maybe don't keep comments about IBM in here? ;)
Github::Processor.new().issues(open: false)