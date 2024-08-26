
#!/bin/ 
#!/bin/bash

# Input YAML file
input_file="input.yaml"
# Output YAML file (can be the same as input_file if you want to overwrite it)
output_file="output.yaml"

awk '
  # Capture the value of name and store it
  /name: / {
    match($0, /name: "([^"]*)"/, arr);
    name = arr[1];
    next;
  }
  # Replace the value field with the format {{name}}
  /value: / {
    sub(/value: "([^"]*)"/, "value: \"{{" name "}}\"");
  }
  # Print each line of the file
  { print }
' $input_file > $output_file

echo "YAML file modified and saved as $output_file."
