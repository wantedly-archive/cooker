name "default"
description "Default run list"
run_list(
  "recipe[homebrew]",
  "recipe[homebrew::bundle]"
)
override_attributes({
  "homebrew" => {
    "formulas" => [
      "git",
    ],
    "casks" => [
      "google-chrome"
    ]
  }
})
