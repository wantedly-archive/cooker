base_path = File.expand_path("..", __FILE__)

cookbook_path []
cookbook_path << File.join(base_path, "cookbooks")
cookbook_path << File.join(base_path, "our-cookbooks")

role_path                 File.join(base_path, "roles")
nodes_path                File.join(base_path, "nodes")
data_bag_path             File.join(base_path, "data_bag")
encrypted_data_bag_secret File.join(base_path, "data_bag_key")
environment_path          File.join(base_path, "environments")
environment               "_default"
json_attribs              "nodes/localhost.json"
file_cache_path           "/var/chef/cache"
