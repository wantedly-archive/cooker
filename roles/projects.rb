name "projects"
description "Run list for each project."
run_list(
  "recipe[homebrew]",        # Don't remove this
  "recipe[homebrew::bundle]" # Don't remove this
  # Add recipes to run here
)
override_attributes({
  "homebrew" => {
    "formulas" => [
      # Add formulas to install here
    ],
    "casks" => [
      # Add casks to install here
    ]
  }
})
