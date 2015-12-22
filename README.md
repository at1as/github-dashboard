# GitHub Dashboard

Stats for this account's GitHub repos built ontop of [Dashing](http://shopify.github.com/dashing).


### Screenshot

![Screenshot](http://at1as.github.io/github_repo_assets/git-dash.jpg)


### Demo

See live demo no [Heroku](http://git-dash.herokuapp.com/)

Note, due to GH rate limiting API, stats are only pulled every 5 - 60 minutes. Heroku app may sleep before stats present themselves


### Usage

* Currently hardcoded to `at1as` github repos
* Start application with access token credentials for a less restrictive rate limit:

```$ GHNAME=<GitHub User Name> GHPWD=<GitHub Access Token> bundle exec dashing start```

Note, GHNAME and GHPWD are only used in order to attain a better rate limit, they don't change the
repos analysed from those created by the at1as account

