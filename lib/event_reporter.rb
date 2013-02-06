require_relative 'prompt'

prompt = Prompt.new("Welcome to EventReporter")
prompt.run 

# To Do
## 1) Print error message when user types in unrecognized commands such as: "queue find first_name John"
## 2) Adjust gutter size to accomodate searches such as: "find state DC"
## 3) In "load_file" method check if file exists in the current directory