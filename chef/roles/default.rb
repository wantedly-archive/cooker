name "default"
description "Default run list"
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
run_list(
  "recipe[homebrew]",
  "recipe[homebrew::bundle]"
)
