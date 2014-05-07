# Cooker
Bootstrap Your Mac.

This is just a chef-solo wrapper to configure laptop(os x only!).
It was very inspired by github boxen and pivotal sprout.

## GETTING STARTED
Install Xcode, Command Line Tools, Homebrew, Chef...etc.

```bash
$ git clone https://github.com/wantedly/cooker.git && cd cooker
$ script/cooker
```

In case you see errors during installing rbenv 2.1.1, please run the following.
```brew uninstall readline
brew install https://raw.githubusercontent.com/Homebrew/homebrew/0181c8a1633353affefabe257c170edbd6d7c008/Library/Formula/readline.rb
brew pin readline
```

## HOW TO USE
### Configure Projects Settings
If your project need to install some homebrew formulas/casks,
just add the formulas/casks to `roles/projects.rb` (chef role file)

This is an example that adding git, openssl, chrome, hipchat, dropbox.

```ruby
name "projects"
description "Run list for each project."
run_list(
  "recipe[homebrew]",        # Don't remove this
  "recipe[homebrew::bundle]" # Don't remove this
)
override_attributes({
  "homebrew" => {
    "formulas" => [
      "git",
      "openssl",
    ],
    "casks" => [
      "google-chrome",
      "hipchat",
      "dropbox"
    ]
  }
})
```

Also, you can write a chef recipe.
Add your recipe under `cookbooks/projects/recipes`

```ruby
log "Welcome to some project!"
```

and add your recipe to run list in projects role.

```ruby
name "projects"
description "Run list for each project."
run_list(
  "recipe[homebrew]",         # Don't remove this
  "recipe[homebrew::bundle]", # Don't remove this
  "recipe[projects::your-project-recipe]"
)
override_attributes({
  "homebrew" => {
    "formulas" => [
      "git",
      "openssl",
    ],
    "casks" => [
      "google-chrome",
      "hipchat",
      "dropbox"
    ]
  }
})

```

### Configure Personal Settings
Same as projects setting, you can write a personal recipe under
 `cookbooks/people/recipes` directory.

For example, if your username in mac is 'seigo',
 you need to create a file named `seigo.rb`.

This recipe will be added to run list automatically.
