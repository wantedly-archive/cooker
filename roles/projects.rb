name "projects"
description "Run list for each project."
run_list(
  "recipe[homebrew]",         # Don't remove this
  "recipe[homebrew::bundle]", # Don't remove this
  "recipe[ruby_build]",
  "recipe[os_x::ruby]"
)
override_attributes({
  "homebrew" => {
    "formulas" => [
      #
      # basic formulas
      #
      "git",
      "hub",
      "bash-completion",
      "ruby-build",
      "rbenv",
      "heroku-toolbelt",
      #
      # for wantedly/wantedly
      #
      "imagemagick",
      "phantomjs",
      "openssl",
      "readline"
    ],
    "casks" => [
      "google-chrome",
      "hipchat",
      "skitch",
      "evernote",
      "dropbox",
      "dropbox-encore"
    ]
  },
  "rbenv"    => {
    "user_installs" => [
      {
        "user"   => ENV['HOME'].sub("\/Users\/", ""),
        "rubies" => ["2.1.1"],
        "global" => "2.1.1",
        "gems"   => {
          "2.1.1" => [
            { "name" => "bundler" },
            { "name" => "rails" },
            { "name" => "chef" },
            { "name" => "berkshelf" },
          ]
        }
      }
    ]
  }
})
