name "default"
description "Default run list"
override_attributes({
  "homebrew" => {
    "formulas" => [
      "git",
      "hub",
      "bash-completion",
      "ruby-build",
      "rbenv",
      "wget",
      "jq",
      "tree",
      "icu4c"
    ]
  }
})
run_list(
  "recipe[homebrew]",
  "recipe[homebrew::bundle]"
)
