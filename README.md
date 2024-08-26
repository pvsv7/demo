
#!/bin/bash

# Input YAML file
input_file="input.yaml"
# Output YAML file (can be the same as input_file if you want to overwrite it)
output_file="output.yaml"

# Use sed to modify the file
sed -E -e '
  # Look for lines with "name: <value>"
  /name: / {
    # Capture the name value (e.g., "abc")
    s/.*name: "(.*)".*/\1/p
  }
  # For the lines with "value: <value>", replace with "value: "{{name}}""
  /value: / {
    N; # Get the next line to include the name field
    s/value: "(.*)"/value: "{{\1}}"/
  }
' $input_file > $output_file

echo "YAML file modified and saved as $output_file."
