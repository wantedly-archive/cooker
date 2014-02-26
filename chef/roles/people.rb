name "people"
description "Run list for each member."

current_user = ENV['HOME'].sub("\/Users\/", "")
user_recipe  = []
Chef::Config[:cookbook_path].each do |path|
  if File.exists?("#{path}/people/recipes/#{current_user}.rb")
    user_recipe = "recipe[people::#{current_user}]"
  end
end

run_list(
  user_recipe
)
override_attributes({
})
